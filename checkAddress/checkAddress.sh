#!/bin/bash

# Check if an argument is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 email_address"
  exit 1
fi

# Extract the domain from the email address
email_address=$1
echo -e "\U1f50e Checking $email_address \U1f50e"
echo
domain=$(echo $email_address | awk -F '@' '{print $2}')

# Check if the domain is valid
if [ -z "$domain" ]; then
  echo "Invalid email address format."
  exit 1
fi

# Run dig to get MX records
echo "Looking for mail servers on domain: $domain"
echo
mx_records=$(dig +short "$domain" mx)

# Check if dig command was successful and MX records were found
if [ -z "$mx_records" ]; then
  echo "No MX records found or dig command failed. Exiting."
  exit 1
fi

# Display the MX records
echo "Available mail servers:"
echo "$mx_records"
echo

# Prompt the user to supply the address of a mail server
echo -n "Enter the address of a mail server: "
read -r mail_server
echo 

# Check if mail_server is empty
if [ -z "$mail_server" ]; then
  echo "No mail server address provided. Exiting."
  exit 1
fi

# Establish a telnet connection to the mail server on port 25
echo "Checking the email address on the mail server"
telnet_output=$( { 
  {
    sleep 2
    echo "HELO $domain"
    sleep 1
    echo "MAIL FROM:<test@example.com>"
    sleep 1

    echo "RCPT TO:<$email_address>"
    sleep 1
    echo "QUIT"
  } | telnet "$mail_server" 25
} 2>&1 )

rcpt_to_response=$(echo "$telnet_output" | grep '250 2.1.5')

if [ -n "$rcpt_to_response" ]; then
  echo -e "\U2705 RCPT TO:<$email_address> succeeded. Email address is probably OK"
else
  echo -e "\U274C RCPT TO:<$email_address> failed. Email address is unreachable or doesn't exist."
  echo
  echo "Telnet output:"
  echo "$telnet_output"
fi
