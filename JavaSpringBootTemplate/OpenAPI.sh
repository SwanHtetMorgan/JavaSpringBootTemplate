#!/bin/bash

helper() {
   echo "Usage  : $0 -p <package_name> -n <openapi_config> -t <title> -v <version> -d <description>"
   echo "Example: $0 -p com.dev.controllers -n myOpenAPIConfig -t 'My API' -v 1.0 -d 'API description'"
}

checker(){
   if [[ $PWD != *"/src/main/java/"* ]]; then
      echo "Please run inside the src folder or their subdir"
      exit 1  # Exiting with non-zero status indicating an error
   fi
}

while getopts "p:n:t:v:d:h" opt; do
   case ${opt} in
      p)
         PACKAGE_NAME=${OPTARG}
         ;;
      n)
         OPENAPICONFIG=${OPTARG}
         ;;
      t)
        TITLE=${OPTARG}
        ;;
      v)
        VERSION=${OPTARG}
        ;;
      d)
        DESCRIPTION=${OPTARG}
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

checker

if [ -z "$PACKAGE_NAME" ] || [ -z "$OPENAPICONFIG" ]; then
   echo "All arguments must be provided"
   helper
   exit 1
fi

PACKAGE_PATH=$(echo "$PACKAGE_NAME" | tr '.' '/')

TARGET_DIR="./$PACKAGE_PATH"

mkdir -p "$TARGET_DIR"

if [ $? -ne 0 ]; then
  echo "Failed to create OpenAPI Configuration"
  exit 1
fi

OPENAPICONFIGFILE="$TARGET_DIR/$OPENAPICONFIG.java"
cat <<EOL >"$OPENAPICONFIGFILE"
package $PACKAGE_NAME;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;
import java.util.List;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class $OPENAPICONFIG {

  @Bean
  public OpenAPI defineOpenApi() {
    Server server = new Server();
    server.setUrl("http://localhost:8080");
    server.setDescription("Development");

    Contact myContact = new Contact();
    myContact.setName("$TITLE");
    myContact.setEmail("eduverse-contact@gmail.com");

    Info information =
        new Info()
            .title("$TITLE")
            .version("$VERSION")
            .description("$DESCRIPTION")
            .contact(myContact);
    return new OpenAPI().info(information).servers(List.of(server));
  }
}
EOL

if [ $? -eq 0 ]; then
  echo "$OPENAPICONFIG created successfully"
  exit 0
else
  echo "Failed to create $OPENAPICONFIG"
  exit 1
fi

