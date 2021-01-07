az mysql server restore --resource-group matomo-staging-rg01 --name mysqlmatomostaging01 --restore-point-in-time 2020-12-04T07:21:00Z --source-server "/subscriptions/9f4c4acc-18ec-4cd9-bc23-b2fa215d182b/resourceGroups/matomo-prod-rg01/providers/Microsoft.DBforMySQL/servers/mysqlmatomoprod"

az mysql server show --name mysqlmatomoprod --resource-group matomo-prod-rg01