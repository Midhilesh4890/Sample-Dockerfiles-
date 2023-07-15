# This is for Pyodbc to run in containers with Kerberos Authentication
# Use a base image with the desired operating system and dependencies
FROM <base_image>

# Install necessary packages for Kerberos and ODBC
RUN apt-get update && \
    apt-get install -y krb5-user unixodbc unixodbc-dev

# Install the necessary PyODBC package
RUN pip install pyodbc

# Copy the Kerberos configuration files to the container
COPY krb5.conf /etc/krb5.conf
COPY keytab.keytab /path/to/keytab.keytab

# Set environment variables for Kerberos
ENV KRB5_CONFIG=/etc/krb5.conf
ENV KRB5_KTNAME=/path/to/keytab.keytab

# Install the Hive ODBC driver
RUN wget https://downloads.cloudera.com/connectors/hive_odbc_2.6.1.1001/Debian/clouderahiveodbc_2.6.1.1001-2_amd64.deb && \
    dpkg -i clouderahiveodbc_2.6.1.1001-2_amd64.deb && \
    apt-get install -f -y

# Copy the ODBC configuration files to the container
COPY odbcinst.ini /etc/odbcinst.ini
COPY odbc.ini /etc/odbc.ini

# Copy your application code into the container
COPY app.py /path/to/app.py

# Set the working directory
WORKDIR /path/to/

# Start your application
CMD ["python", "app.py"]
