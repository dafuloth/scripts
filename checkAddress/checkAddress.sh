#!/bin/bash

# Check if an argument is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 email_address"
  exit 1
fi

# Extract the domain from the email address
email_address=$1
echo "Checking $email_address"
domain=$(echo $email_address | awk -F '@' '{print $2}')

# Check if the domain is valid
if [ -z "$domain" ]; then
  echo "Invalid email address format."
  exit 1
fi

# Run nslookup to get the MX records
echo "Running nslookup for domain: $domain"
nslookup_output=$(nslookup -type=mx "$domain")
if [ $? -ne 0 ]; then
  echo "Error running nslookup. Exiting."
  exit 1
fi

# Display the output of nslookup
echo "$nslookup_output"

# Prompt the user to supply the address of a mail server
echo -n "Enter the address of a mail server: "
read -r mail_server

# Check if mail_server is empty
if [ -z "$mail_server" ]; then
  echo "No mail server address provided. Exiting."
  exit 1
fi

# Establish a telnet connection to the mail server on port 25
echo "Connecting to $mail_server on port 25..."
telnet_output=$( { 
  {
    sleep 2
    echo "HELO $domain"
    sleep 2
    echo "MAIL FROM:<test@gmail.com>"
    sleep 2
    echo "RCPT TO:<$email_address>"
    sleep 2
    echo "QUIT"
    sleep 2
  } | telnet "$mail_server" 25
} 2>&1 )

rcpt_to_response=$(echo "$telnet_output" | grep '250 2.1.5')

if [ -n "$rcpt_to_response" ]; then
  echo "RCPT TO command successful. Email address is probably OK"
else
  echo "RCPT TO command failed. Email address is unreachable or doesn't exist"
fi
