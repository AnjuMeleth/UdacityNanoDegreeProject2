#!/bin/bash
echo "Checking if $1 stack exists ..."

if ! aws cloudformation describe-stacks --region us-west-2 --stack-name $1 ; then

  echo -e "\nStack does not exist, creating ..."
  aws cloudformation create-stack \
  --stack-name $1 \
  --template-body file://$2 \
  --parameters file://$3 \
  --region=us-west-2 \
  --capabilities CAPABILITY_IAM 
  
  echo "Waiting for stack $1 to be created ..."
  aws cloudformation wait stack-create-complete --stack-name $1 --region=us-west-2

else

  echo -e "\nStack exists, attempting update ..."

  
  update_output=$( aws cloudformation update-stack \
    --stack-name $1 \
    --template-body file://$2 \
    --parameters file://$3 \
    --region=us-west-2 \
    --capabilities CAPABILITY_IAM )
  
  status=$?
  

  echo "$update_output"

  if [ $status -ne 0 ] ; then

    # Don't fail for no-op update
    if [[ $update_output == *"ValidationError"* && $update_output == *"No updates"* ]] ; then
      echo -e "\nFinished create/update - no updates performed"
      exit 0
    else
      exit $status
    fi
  fi
  
  echo "Waiting for stack $1 update to complete ..."
  aws cloudformation wait stack-update-complete --stack-name $1 --region=us-west-2

fi

echo "Finished create/update successfully!"