# Augo Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

We take the security of **Augo** seriously. If you discover a security issue, please report it responsibly.

### How to Report

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead, please send an email to the project maintainers with a clear description of the vulnerability, reproduction steps, and potential impact.

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Resolution Target**: Within 30 days for critical issues

## Security Best Practices

When deploying Augo, please ensure:

### Environment Variables
- **Never** use default/example values in production.
- Generate secure `JWT_SECRET_KEY` and `ENCRYPTION_KEY` using `make gen-keys`.

### Infrastructure
- Always use **HTTPS** in production.
- Use strong, unique passwords for the PostgreSQL database.
- Restrict network access to the database and Redis instances.

## Acknowledgments

We appreciate the security research community's efforts in helping keep Augo secure.
