#!/bin/bash

set -e
    
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 
echo -e "${YELLOW} Etapa 1: Configurando as variáveis do ambiente...${NC}"

RESOURCE_GROUP="rg-challenge-fiap-557884"
LOCATION="brazilsouth"
DB_SERVER_NAME="sql-motoconnect-557884"
DB_NAME="motoconnectdb"
APP_SERVICE_PLAN="asp-motoconnect-fiap-557884"
WEB_APP_NAME="webapp-motoconnect-557884"
GITHUB_REPO="https://github.com/mateush-souza/challenge-moto-connect"


DB_ADMIN_USER="<SEU_USUARIO_ADMIN>"
DB_ADMIN_PASSWORD="<SUA_SENHA_FORTE>"

echo "  > Variáveis configuradas para o RM 557884."

# --- Etapa 2: Criação da Infraestrutura ---

echo -e "\n${YELLOW}Etapa 2: Criando a infraestrutura na Azure...${NC}"

echo "  > Criando o Grupo de Recursos: ${RESOURCE_GROUP}..."
az group create --name $RESOURCE_GROUP --location $LOCATION --output none
echo -e "  ${GREEN}✓ Grupo de Recursos criado.${NC}"

echo "  > Criando o Servidor Azure SQL: ${DB_SERVER_NAME}..."
az sql server create --name $DB_SERVER_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --admin-user $DB_ADMIN_USER --admin-password $DB_ADMIN_PASSWORD --output none
echo -e "  ${GREEN}✓ Servidor SQL criado.${NC}"

echo "  > Configurando a regra de firewall do servidor..."
az sql server firewall-rule create --resource-group $RESOURCE_GROUP --server $DB_SERVER_NAME -n AllowAllWindowsAzureIps --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0 --output none
echo -e "  ${GREEN}✓ Regra de firewall configurada.${NC}"

echo "  > Criando o Banco de Dados: ${DB_NAME}..."
az sql db create --resource-group $RESOURCE_GROUP --server $DB_SERVER_NAME --name $DB_NAME --service-objective S0 --output none
echo -e "  ${GREEN}✓ Banco de Dados criado.${NC}"

echo "  > Criando o Plano do App Service: ${APP_SERVICE_PLAN}..."
az appservice plan create --name $APP_SERVICE_PLAN --resource-group $RESOURCE_GROUP --sku F1 --is-linux --output none
echo -e "  ${GREEN}✓ Plano do App Service criado.${NC}"

# --- Etapa 3: Deploy da Aplicação ---

echo -e "\n${YELLOW}Etapa 3: Realizando o deploy da aplicação...${NC}"

echo "  > Criando o Web App e configurando o deploy a partir do GitHub..."
az webapp create --resource-group $RESOURCE_GROUP --plan $APP_SERVICE_PLAN --name $WEB_APP_NAME --runtime "DOTNET|8.0" --deployment-source-url $GITHUB_REPO --deployment-source-branch main --output none
echo -e "  ${GREEN}✓ Web App criado e deploy iniciado.${NC}"

echo "  > Obtendo a Connection String do banco de dados..."
CONNECTION_STRING=$(az sql db show-connection-string --client ado.net --name $DB_NAME --server $DB_SERVER_NAME -o tsv)

echo "  > Injetando a Connection String no App Service..."
az webapp config connection-string set \
    --resource-group $RESOURCE_GROUP \
    --name $WEB_APP_NAME \
    --settings DefaultConnection="$CONNECTION_STRING" \
    --connection-string-type SQLAzure --output none
echo -e "  ${GREEN}✓ Connection String configurada com sucesso.${NC}"

# --- Etapa 4: Finalização ---

WEBAPP_URL="https://$WEB_APP_NAME.azurewebsites.net"

echo -e "\n\n${GREEN}======================================================${NC}"
echo -e "${GREEN} DEPLOY CONCLUÍDO COM SUCESSO! ${NC}"
echo -e "${GREEN}======================================================${NC}"
echo -e "A sua API está disponível em: ${YELLOW}$WEBAPP_URL${NC}"
echo "Aguarde alguns minutos para o build inicial do App Service terminar."
echo "Pode acompanhar o progresso em 'Centro de Implantação' no Portal da Azure."