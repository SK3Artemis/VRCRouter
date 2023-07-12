#!/bin/bash

VERSION="1.0.1"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo $VERSION
echo $DATE

cat > "vrcrouter-netf/vrcrouter-common/Build.cs" <<- EOM
namespace ValueFactoryVRCRouterCommon {
  public static class Build {
    #if DEBUG
      public static string build_version = "DEBUG";
      public static string build_date = "DEBUG";
    #else
      public static string build_version = "${VERSION}";
      public static string build_date = "${DATE}";
    #endif
  }
}
EOM


echo == Compiling VRCRouter 
/cygdrive/c/Program\ Files/Microsoft\ Visual\ Studio/2022/Community/Msbuild/Current/Bin/MSBuild.exe -p:Configuration=Release vrcrouter-netf/vrcrouter/vrcrouter.csproj

echo == Compiling VRCRouter Configuration
/cygdrive/c/Program\ Files/Microsoft\ Visual\ Studio/2022/Community/Msbuild/Current/Bin/MSBuild.exe -p:Configuration=Release vrcrouter-netf/vrcrouter-config/vrcrouter-config.csproj

echo == Compiling VRCRouter Common
/cygdrive/c/Program\ Files/Microsoft\ Visual\ Studio/2022/Community/Msbuild/Current/Bin/MSBuild.exe -p:Configuration=Release vrcrouter-netf/vrcrouter-common/vrcrouter-common.csproj

echo == Compiling VRCRouter Native
cd "vrcrouter-native"
./compile_native_release.sh
cd ../

echo == Copying Stuff

mkdir -p "ship/staging/"

cp "vrcrouter-netf/vrcrouter/bin/Release/VRCRouter.exe" "ship/staging/"
cp "vrcrouter-netf/vrcrouter/bin/Release/Newtonsoft.Json.dll" "ship/staging/"

cp "vrcrouter-netf/vrcrouter-config/bin/Release/VRCRouter Configuration.exe" "ship/staging/"

cp "vrcrouter-netf/vrcrouter-common/bin/Release/vrcrouter_common.dll" "ship/staging/"
cp "vrcrouter-native/vrcrouter_native.dll" "ship/staging/"

echo DONE
