#!/usr/bin/env python3
"""Generate and display an ASCII QR code containing the server URL.
This is used by manage.sh to help users configure the mobile app.
"""

import os
import socket
import subprocess
import sys


def get_local_ip():
    """Get the local IP address of this machine (preferring real network interfaces)."""
    # Method 1: Try to get IP from hostname
    try:
        hostname = socket.gethostname()
        ip = socket.gethostbyname(hostname)
        # Avoid localhost or Docker IPs (172.x.x.x is often Docker)
        if ip and not ip.startswith("127.") and not ip.startswith("172."):
            return ip
    except Exception:
        pass

    # Method 2: Parse ip route to get the default interface IP
    try:
        result = subprocess.run(["ip", "route", "get", "1.1.1.1"], capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            # Output like: "1.1.1.1 via 192.168.1.1 dev eth0 src 192.168.1.100 uid 1000"
            parts = result.stdout.split()
            for i, part in enumerate(parts):
                if part == "src" and i + 1 < len(parts):
                    ip = parts[i + 1]
                    if not ip.startswith("172."):  # Skip Docker IPs
                        return ip
    except Exception:
        pass

    # Method 3: List all interfaces and find non-Docker ones
    try:
        result = subprocess.run(["hostname", "-I"], capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            ips = result.stdout.strip().split()
            for ip in ips:
                # Prefer 192.168.x.x or 10.x.x.x (typical LAN IPs)
                if ip.startswith("192.168.") or ip.startswith("10."):
                    return ip
            # Fallback to first non-Docker IP
            for ip in ips:
                if not ip.startswith("172.") and not ip.startswith("127."):
                    return ip
    except Exception:
        pass

    # Method 4: Connect to external address (fallback, may get Docker IP)
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.settimeout(2)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        return local_ip
    except Exception:
        pass

    return "127.0.0.1"


def generate_qr_code(url: str, local_ip: str):
    """Generate and print ASCII QR code for the given URL."""
    try:
        import qrcode
    except ImportError:
        print("⚠️  qrcode package not installed. To enable QR codes:")
        print("   uv add qrcode")
        print(f"\n📱 Server URL: {url}")
        print("   Enter this URL manually in the app.")
        return

    # Create QR code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=1,
        border=1,
    )
    qr.add_data(url)
    qr.make(fit=True)

    # Print header
    print("\n" + "=" * 50)
    print("📱 Mobile App Server Configuration")
    print("=" * 50)
    print(f"\n🔗 Server URL: {url}")

    # Show alternative URLs
    print("\n💡 Alternative addresses:")
    print("   - For Android Emulator: http://10.0.2.2:8000")
    if local_ip != "127.0.0.1":
        print(f"   - For real devices on same network: {url}")
    print("   - For localhost: http://localhost:8000")

    print("\nScan this QR code with the Augo app:\n")

    # Print ASCII QR code
    qr.print_ascii(invert=True)

    print("\nOr enter the URL manually in the app.")
    print("=" * 50 + "\n")


def main():
    """Execution entry point for the script."""
    # Get port from environment or default to 8000
    port = os.environ.get("PORT", "8000")

    # Get the local IP
    local_ip = get_local_ip()

    # Construct the server URL
    server_url = f"http://{local_ip}:{port}"

    generate_qr_code(server_url, local_ip)


if __name__ == "__main__":
    main()
