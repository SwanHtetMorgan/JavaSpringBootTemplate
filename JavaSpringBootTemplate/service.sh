#!/bin/bash

helper() {
   echo "Usage  : $0 -p <package_name> -s <services> -e <entity>"
   echo "Example: $0 -p com.dev.controllers -s myService -e User"
}

check_directory() {
   if [[ $PWD != *"/src/main/java"* ]]; then
      echo "Please execute the script from the src/main/java directory or its subdirectories."
      exit 1
   fi
}

while getopts "p:s:e:h" opt; do
   case ${opt} in
      p)
         PACKAGE_NAME=${OPTARG}
         ;;
      s)
         SERVICES=${OPTARG}
         ;;
      e)
         ENTITY_NAME=${OPTARG}
         ;;
      h)
         helper
         exit 0
         ;;
      ?)
        echo "Invalid Option: -$OPTARG" >&2
         helper
         exit 1
         ;;
      :)
         echo "Option -$OPTARG requires an argument" >&2
         helper
         exit 1
         ;;
   esac
done

check_directory

if [ -z "$PACKAGE_NAME" ] || [ -z "$SERVICES" ] || [ -z "$ENTITY_NAME" ]; then
   echo "All arguments are required"
   helper
   exit 1
fi

PACKAGE_PATH=$(echo "$PACKAGE_NAME" | tr '.' '/')
ENTITY_NAME_LOWER=$(echo "$ENTITY_NAME" | tr '[:upper:]' '[:lower:]')

TARGET_DIR="./$PACKAGE_PATH"

mkdir -p "$TARGET_DIR"

if [ $? -ne 0 ]; then
  echo "Failed to create the services directory: $TARGET_DIR"
  exit 2
fi

SERVICES_INTERFACE="$TARGET_DIR/$SERVICES.java"
cat <<EOL > "$SERVICES_INTERFACE"
package $PACKAGE_NAME;
import java.util.List;
public interface $SERVICES {
    List<$ENTITY_NAME> get$ENTITY_NAME();

    $ENTITY_NAME get$ENTITY_NAME(Long id);

    $ENTITY_NAME create$ENTITY_NAME($ENTITY_NAME $ENTITY_NAME_LOWER);

    $ENTITY_NAME update$ENTITY_NAME(Long id, $ENTITY_NAME $ENTITY_NAME_LOWER);

    boolean delete$ENTITY_NAME(Long id);
}
EOL

if [ $? -eq 0 ]; then
  echo "$SERVICES interface created successfully in $TARGET_DIR"
  exit 0
else
  echo "Failed to create $SERVICES interface in $TARGET_DIR"
  exit 1
fi
