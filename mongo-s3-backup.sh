#!/bin/sh

# Current time
TIME=`/bin/date +%d-%m-%Y-%T`

# Backup directory
DEST=/app/tmp

# Tar file of backup directory
TAR=$DEST/$TIME.tar

# Create backup dir (-p to avoid warning if already exists)
/bin/mkdir -p $DEST

# Log
echo "Backing up $MONGO_HOST:$MONGO_PORT/$MONGO_DATABASE to s3://$AWS_MONGO_BACKUP_PATH/ on $TIME";

# Dump from mongodb host into backup directory
if [ -z ${MONGO_USERNAME+x} ] || [ -z ${MONGO_PASSWORD+x} ] || [ "$MONGO_USERNAME" = "" ] || [ "$MONGO_PASSWORD" = "" ]
then
  mongodump --gzip --host $MONGO_HOST --port $MONGO_PORT -d $MONGO_DATABASE -o $DEST
else
  mongodump --gzip --host $MONGO_HOST --port $MONGO_PORT --username $MONGO_USERNAME --password $MONGO_PASSWORD -d $MONGO_DATABASE -o $DEST
fi

# Create tar of backup directory
/bin/tar cvf $TAR -C $DEST .

# Upload tar to s3
aws s3 cp $TAR s3://$AWS_MONGO_BACKUP_PATH/

# Remove tar file locally
/bin/rm -f $TAR

# Remove backup directory
/bin/rm -rf $DEST

# All done
echo "Backup available at https://s3.amazonaws.com/$AWS_MONGO_BACKUP_PATH/$TIME.tar"
