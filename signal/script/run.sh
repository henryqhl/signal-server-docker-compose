signalServerProjectName="Signal-Server"
signalServerProjectUrl="https://github.com/henryqhl/${signalServerProjectName}.git"
branch="dockerCompose"
jarsFolder="jars"
workPath=$PWD

function cdRepoAndClean() {
  cd "$workPath/$signalServerProjectName" &&
    git reset --hard &&
    git clean -df
}

function cloneSignalServerProjectAndCheckOutBranch() {
  rm -rf "${workPath:?}/$signalServerProjectName"
  cd "$workPath" || exit
  git clone $signalServerProjectUrl
  cd "${workPath:?}/$signalServerProjectName" || exit
  git checkout $branch
}

function getCommitId() {
  git rev-parse HEAD
}

function build() {
  mvn clean install -DskipTests
  mv service/target/TextSecureServer-*.jar "$1"
}

function start() {
  echo "abusedb migrate ..............................................................................................."
  java -jar "$1" abusedb migrate "$workPath/config/config.yml"
  echo "accountdb migrate ............................................................................................."
  java -jar "$1" accountdb migrate "$workPath/config/config.yml"
  echo "messagedb migrate ............................................................................................."
  java -jar "$1" messagedb migrate "$workPath/config/config.yml"
  #  echo "debug server .................................................................................................."
  #  java -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005 -jar "$1" server "$workPath/config/config.yml"
  echo "start server .................................................................................................."
  java -jar "$1" server "$workPath/config/config.yml"

}

if ! cdRepoAndClean; then
  cloneSignalServerProjectAndCheckOutBranch
fi
cd "$workPath/$signalServerProjectName" || exit
commitId=$(getCommitId)
echo "Commit ID: ${commitId}"
if [[ ! -f $workPath/$jarsFolder/$commitId.jar ]]; then
  build "$workPath/$jarsFolder/$commitId.jar"
fi
echo "run with $commitId.jar"
start "$workPath/$jarsFolder/$commitId.jar"
