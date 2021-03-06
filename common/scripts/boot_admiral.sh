#!/bin/bash -e

__boot_admiral() {
  local admiral_container=$(sudo docker ps | grep admiral | awk '{print $1}')
  if [ "$admiral_container" != "" ]; then
    __process_msg "Admiral container already running"
  else
		__process_msg "Generating admiral ENV variables"
		local envs=" -e DBNAME=$DB_NAME \
			-e DBUSERNAME=$DB_USER \
			-e DBPASSWORD=$DB_PASSWORD \
			-e DBDIALECT=$DB_DIALECT \
			-e DBHOST=$DB_IP \
			-e DBPORT=$DB_PORT \
			-e RUN_MODE=$RUN_MODE \
			-e LOGIN_TOKEN=$LOGIN_TOKEN \
			-e ADMIRAL_IP=$ADMIRAL_IP \
			-e RELEASE=$RELEASE \
			-e INSTALL_MODE=$INSTALL_MODE \
			-e CONFIG_DIR=$CONFIG_DIR \
			-e RUNTIME_DIR=$RUNTIME_DIR \
			-e MIGRATIONS_DIR=$MIGRATIONS_DIR \
			-e VERSIONS_DIR=$VERSIONS_DIR"

		__process_msg "Generating admiral mounts"
		local mounts=" -v $CONFIG_DIR:$CONFIG_DIR \
			-v $RUNTIME_DIR:$RUNTIME_DIR "

		local admiral_image="shipimg/admiral:$RELEASE"

		local boot_cmd="sudo docker run -d \
			$envs \
			$mounts \
			--publish 50003:50003 \
			--net=bridge \
			--name=admiral \
			$admiral_image"

		__process_msg "Executing: $boot_cmd"

		eval "$boot_cmd"
		__process_msg "Admiral container successfully running"
	fi
}

main() {
	__process_marker "Booting Admiral UI"
	__boot_admiral
}

main
