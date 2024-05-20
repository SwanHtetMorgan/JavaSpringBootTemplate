#!/bin/bash

helper() {
   echo "Usage  : $0 -p <package_name> -c <controller> -e <entity>"
   echo "Example: $0 -p com.dev.controllers -c MyController -e User"
}

# Check if the script is executed from within src/main/java directory or its subdirectories
check_directory() {
    if [[ $PWD != *"/src/main/java"* ]]; then
        echo "Please execute the script from the src/main/java directory or its subdirectories."
        exit 1
    fi
}

while getopts "p:c:e:h" opt; do
   case ${opt} in
      p)
         PACKAGE_NAME=${OPTARG}
         ;;
      c)
         CONTROLLER_NAME=${OPTARG}
         ;;
      e)
         ENTITY_NAME=${OPTARG}
         ;;
      h)
         helper
         exit 0
         ;;
      \?)
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

# Check current directory
check_directory

if [ -z "$PACKAGE_NAME" ] || [ -z "$CONTROLLER_NAME" ] || [ -z "$ENTITY_NAME" ]; then
   echo "All arguments are required"
   helper
   exit 1
fi

PACKAGE_PATH=$(echo "$PACKAGE_NAME" | tr '.' '/')
ENTITY_NAME_LOWER=$(echo "$ENTITY_NAME" | tr '[:upper:]' '[:lower:]')

TARGET_DIR="./$PACKAGE_PATH"

mkdir -p "$TARGET_DIR"
if [ $? -ne 0 ]; then
   echo "Failed to create directory $TARGET_DIR"
   exit 1
fi

CONTROLLER_CLASS="$TARGET_DIR/$CONTROLLER_NAME.java"
cat <<EOL > "$CONTROLLER_CLASS"
package $PACKAGE_NAME;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.validation.annotation.Validated;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/api/$ENTITY_NAME_LOWER")
public class $CONTROLLER_NAME {

    @GetMapping("")
    public ResponseEntity<?> getAll$ENTITY_NAME() {
        // Implement the logic
        return null;
    }

    @PostMapping("/")
    public ResponseEntity<?> create$ENTITY_NAME(@Validated @RequestBody $ENTITY_NAME requestBody) {
        // Implement the logic
        return null;
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update$ENTITY_NAME(@PathVariable Long id, @Validated @RequestBody $ENTITY_NAME requestBody) {
        // Implement the logic
        return null;
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete$ENTITY_NAME(@PathVariable Long id) {
        // Implement the logic
        return null;
    }
}
EOL

if [ $? -eq 0 ]; then
    echo "Spring Boot controller created successfully"
    echo "Controller: $CONTROLLER_NAME"
else
    echo "Failed to create Spring Boot controller"
    exit 1
fi

exit 0
