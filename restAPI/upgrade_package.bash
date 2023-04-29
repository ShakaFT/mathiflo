# This script upgrade restAPI-package to latest version

export $(cat .env | xargs) >/dev/null 2>&1
pip install git+https://$RESTAPI_PACKAGE_USERNAME:$RESTAPI_PACKAGE_TOKEN@github.com/ShakaFT/restAPI-package.git --upgrade
