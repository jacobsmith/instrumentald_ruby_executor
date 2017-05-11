curl -s https://api.heroku.com/apps/$APP_NAME_TO_COUNT_DYNOS/dynos -H "Accept: application/vnd.heroku+json; version=3"  -H "Authorization: Bearer $API_KEY_FOR_HEROKU" |
grep type                            | # look for the line in each response that looks like: "type": "web",
cut -d ':' -f 2                      | # take only "web",
sed s/\"//g                          | # remove the quotation marks
sed s/,//g                           | # remove the comma
xargs -L 1 echo $1                   | # echo an identifier for each, i.e., heroku.dyno.web.count
sed 's/ //g'                         | # remove any remaining whitespace (not sure why it's there)
uniq -c                              | # get a count of each unique identifier eg. ( 3 heroku.dyno.web.count \n 2 heroku.dyno.sidekiq.count )
ruby -e 'puts STDIN.read.split("\n").map { |line| line.split(" ").reverse.join(" ") }' # split them, reverse them
