import yaml
import os
import re

def main():
    pubspec_lock_path = '/home/kylesean/projects/python/augo/client/pubspec.lock'
    pub_cache_base = '/home/kylesean/.pub-cache/hosted/pub.dev'
    
    if not os.path.exists(pubspec_lock_path):
        print(f"Error: {pubspec_lock_path} not found.")
        return

    with open(pubspec_lock_path, 'r') as f:
        lock_data = yaml.safe_load(f)

    packages = lock_data.get('packages', {})
    
    results = []
    
    for pkg_name, pkg_info in packages.items():
        version = pkg_info.get('version')
        source = pkg_info.get('source')
        description = pkg_info.get('description', {})
        
        license_type = "Unknown"
        pkg_dir = ""
        
        if source == 'hosted' and description.get('url') == 'https://pub.dev':
            pkg_dir = os.path.join(pub_cache_base, f"{pkg_name}-{version}")
        elif source == 'sdk':
            license_type = "Flutter SDK (BSD-3-Clause)"
        elif source == 'git':
            license_type = "Git Source (Check manually)"
        
        if pkg_dir and os.path.exists(pkg_dir):
            license_files = ['LICENSE', 'LICENSE.txt', 'COPYING', 'LICENSE.md', 'license']
            found_license = False
            for lf in license_files:
                lf_path = os.path.join(pkg_dir, lf)
                if os.path.exists(lf_path):
                    with open(lf_path, 'r', errors='ignore') as lfile:
                        content = lfile.read()
                        license_type = detect_license(content)
                    found_license = True
                    break
            if not found_license:
                license_type = "License file not found"
        elif not license_type or license_type == "Unknown":
            license_type = "Local/Internal or Downloaded elsewhere"

        results.append({
            'name': pkg_name,
            'version': version,
            'license': license_type
        })

    # Print results in a table-like format
    print(f"{'Package':<40} | {'Version':<15} | {'License'}")
    print("-" * 80)
    for res in sorted(results, key=lambda x: x['name']):
        print(f"{res['name']:<40} | {res['version']:<15} | {res['license']}")

def detect_license(content):
    content_lower = content.lower()
    
    if "apache license" in content_lower and "version 2.0" in content_lower:
        return "Apache-2.0"
    if "mit license" in content_lower or ("permission is hereby granted" in content_lower and "software is furnished to do so" in content_lower):
        return "MIT"
    if "bsd 3-clause" in content_lower or "3-clause bsd" in content_lower:
        return "BSD-3-Clause"
    if "bsd 2-clause" in content_lower or "2-clause bsd" in content_lower:
        return "BSD-2-Clause"
    if "bsd license" in content_lower:
        return "BSD"
    if "gnugeneral public license" in content_lower or "gpl" in content_lower:
        if "version 3" in content_lower:
            return "GPL-3.0"
        if "version 2" in content_lower:
            return "GPL-2.0"
        return "GPL"
    if "mozilla public license" in content_lower:
        return "MPL-2.0"
    if "eclipse public license" in content_lower:
        return "EPL"
    
    # Try more aggressive matching for MIT
    if "mit" in content_lower and len(content) < 2000:
        # MIT is usually short
        return "MIT (Probable)"
    
    # Check for Flutter/Dart style BSD
    if "copyright" in content_lower and "redistribution and use in source and binary forms" in content_lower:
        return "BSD-style"

    return "Custom/Unknown (Check Content)"

if __name__ == "__main__":
    main()
