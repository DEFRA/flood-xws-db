APP="flood-xws-contact"
ENV="test"
# SVC="xws-contact-api"
SVC="xws-area-api"

SECRET_ID=$(aws resourcegroupstaggingapi get-resources --tag-filters "Key=copilot-service,Values=$SVC" --resource-type-filters secretsmanager:secret --query "ResourceTagMappingList[0].ResourceARN" --output text)
DB_ENV_VARS=$(aws secretsmanager get-secret-value --secret-id "$SECRET_ID" --query "SecretString" --output text | jq -r '"PGHOST=\(.host),PGPORT=\(.port),PGDATABASE=\(.dbname),PGUSER=\(.username),PGPASSWORD=\(.password)"')

CLUSTER_ID=$(aws ecs list-clusters --query "clusterArns[?contains(@, $(echo \'${APP}-${ENV}\'))]" --output text)
SERVICE_ID=$(aws ecs list-services --cluster "$CLUSTER_ID"  --query "serviceArns[?contains(@, $(echo \'${APP}-${ENV}-${SVC}\'))]" --output text)
TASK_ID=$(aws ecs list-tasks --cluster "$CLUSTER_ID" --service "$SERVICE_ID" --query "taskArns[0]" --output text)
TASK_DEFINITION_ID=$(aws ecs describe-tasks --cluster "$CLUSTER_ID" --tasks "$TASK_ID" --query "tasks[0].taskDefinitionArn" --output text)
TASK_ROLE_ID=$(aws ecs describe-task-definition --task-definition "$TASK_DEFINITION_ID" --query "taskDefinition.taskRoleArn" --output text)
SECURITY_GROUP_ID=$(aws resourcegroupstaggingapi get-resources --tag-filters Key=copilot-service,Values="$SVC" Key=Name,Values="copilot-${APP}-${ENV}-${SVC}-Aurora" --resource-type-filters ec2:security-group --query "ResourceTagMappingList[0].ResourceARN" --output text)
SUBNET_ID=$(aws ecs describe-services --services "$SERVICE_ID" --cluster "$CLUSTER_ID" --query "services[0].networkConfiguration.awsvpcConfiguration.subnets[0]" --output text)

echo "SECRET_ID: $SECRET_ID"
echo "DB_ENV_VARS: $DB_ENV_VARS"
echo "CLUSTER_ID: $CLUSTER_ID"
echo "SERVICE_ID: $SERVICE_ID"
echo "TASK_ID: $TASK_ID"
echo "TASK_DEFINITION_ID: $TASK_DEFINITION_ID"
echo "TASK_ROLE_ID: $TASK_ROLE_ID"
echo "SECURITY_GROUP_ID: $SECURITY_GROUP_ID"
echo "SUBNET_ID: $SUBNET_ID"

# string substitution used for security groups parameter http://mywiki.wooledge.org/BashFAQ/100#Removing_part_of_a_string
copilot task run --env-vars "$DB_ENV_VARS" --dockerfile DockerfileAWS --cluster "${CLUSTER_ID}" --subnets "$SUBNET_ID" --task-role "$TASK_ROLE_ID" --security-groups "${SECURITY_GROUP_ID##*/}" --follow
