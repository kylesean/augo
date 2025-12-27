# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue, please report it responsibly.

### How to Report

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead, please send an email to the project maintainers with:

1. **Description**: A clear description of the vulnerability
2. **Steps to Reproduce**: Detailed steps to reproduce the issue
3. **Impact**: The potential impact of the vulnerability
4. **Suggested Fix**: If you have one, a suggested fix

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Resolution Target**: Within 30 days for critical issues

### What to Expect

1. We will acknowledge receipt of your report
2. We will investigate and validate the issue
3. We will work on a fix and coordinate disclosure
4. We will credit you in the security advisory (unless you prefer anonymity)

## Security Best Practices

When deploying this application, please ensure:

### Environment Variables

- **NEVER** use default/example values in production
- Rotate `JWT_SECRET_KEY` immediately after initial setup
- Generate a new `ENCRYPTION_KEY` using `Fernet.generate_key()`
- Use strong, unique passwords for database credentials

### Database

- Enable SSL/TLS for database connections in production
- Restrict database user permissions to minimum required
- Regularly backup and encrypt sensitive data

### API Security

- Always use HTTPS in production
- Configure CORS appropriately for your domain
- Monitor rate limiting metrics

## Acknowledgments

We appreciate the security research community's efforts in helping keep our project secure.
