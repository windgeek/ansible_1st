ALTER USER postgres WITH PASSWORD '{{postgres_password}}';
CREATE ROLE {{replication_user}} login replication encrypted password '{{replication_password}}';