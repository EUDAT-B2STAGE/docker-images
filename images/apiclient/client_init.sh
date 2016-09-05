
export SERVER=`echo $APISERVER_PORT | sed 's/tcp/http/'`
echo "Using server $SERVER"

echo "Login"
export CREDENTIALS="username=user@nomail.org password=test"
TOKEN=`http POST $SERVER/auth/login $CREDENTIALS | jq '.Response.data.token' | tr -d '"'`

#echo $TOKEN
echo "Logged"
export AUTH="Authorization:Bearer $TOKEN"

echo "You can now query the API SERVER. Examples:"
echo ""
echo "- Query the status endpoint and parse the JSON response"
echo '$ http GET $SERVER/api/status | jq "."'
echo ""
echo "- Query a protected endpoint by passing the saved token"
echo '$ http GET $SERVER/auth/profile "$AUTH"'
