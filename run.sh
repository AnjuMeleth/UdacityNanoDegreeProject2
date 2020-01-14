#!/bin/bash
echo "Checking if $1 stack exists ..."

if ! aws cloudformation describe-stacks --region us-west-2 --stack-name $1 ; then

  echo -e "Stack does not exist, creating $1 ..."
  aws cloudformation create-stack \
  --stack-name $1 \
  --template-body file://$2 \
  --parameters file://$3 \
  --region=us-west-2 \
  --capabilities CAPABILITY_IAM 
  
  echo "Waiting for stack $1 to be created ..."
  aws cloudformation wait stack-create-complete --stack-name $1 --region=us-west-2

else

  echo -e "Stack $1 exists, attempting update ..."

  
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
      echo -e "\nFinished with no updates "
      exit 0
    else
      exit $status
    fi
  fi
  
  echo "Waiting for stack $1 update to finish ..."
  aws cloudformation wait stack-update-complete --stack-name $1 --region=us-west-2

fi

echo "Finished successfully!"