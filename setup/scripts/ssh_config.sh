#!/usr/bin/env zsh
#
# SSH Configuration Script
#
# This script helps migrate SSH files from ~/.ssh to ~/.config/ssh
# and ensures the proper configuration is set up
#

# Exit on error, undefined variables, and propagate errors in pipelines
set -euo pipefail

# Source utility scripts
SSH_SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SSH_SCRIPT_DIR/../utils/colors.sh"

# Generate a new SSH key with custom name
generate_ssh_key() {
    local key_type="$1"
    local key_name="$2"
    local key_comment="$3"
    local key_path="$SSH_NEW_DIR/$key_name"

    step "Generating $key_type SSH key: $key_name"

    # Generate the key
    ssh-keygen -t ed25519 -f "$key_path" -C "$key_comment" -N ""

    # Set proper permissions
    chmod 600 "$key_path"
    chmod 600 "$key_path.pub"

    success "Generated $key_type SSH key: $key_name"
    note "Public key is available at: $key_path.pub"
    echo
    echo "====================== PUBLIC KEY CONTENT ======================="
    cat "$key_path.pub"
    echo "=============================================================="
    echo
}

# Offer to generate new SSH keys
offer_generate_keys() {
    # Check for any OpenSSH private key files, not just ones with specific patterns
    local has_keys=false

    if [[ -d "$SSH_NEW_DIR" ]]; then
        # First check for any existing custom named keys
        if find "$SSH_NEW_DIR" -type f -name "github_*" 2>/dev/null | grep -q .; then
            # Found custom named keys like github_personal, github_work, etc.
            has_keys=true
            step "Found existing custom SSH keys in $SSH_NEW_DIR"
        # Then check for standard key formats if we didn't find custom ones
        elif find "$SSH_NEW_DIR" -type f -name "id_*" 2>/dev/null | grep -q .; then
            # Found standard keys like id_rsa, id_ed25519, etc.
            has_keys=true
            step "Found existing standard SSH keys in $SSH_NEW_DIR"
        fi
    fi

    if [[ "$has_keys" == "false" ]]; then
        note "No SSH keys found in $SSH_NEW_DIR with the prefix 'github_' or standard 'id_'"
        echo -n "Would you like to generate new SSH keys? [y/n] "
        read -r gen_keys_choice

        if [[ "$gen_keys_choice" == "y" || "$gen_keys_choice" == "Y" ]]; then
            # Personal key
            echo -n "Generate a personal GitHub SSH key? [y/n] "
            read -r gen_github_personal

            if [[ "$gen_github_personal" == "y" || "$gen_github_personal" == "Y" ]]; then
                echo -n "Enter a name for this key (default: github_personal): "
                read -r personal_key_name
                personal_key_name=${personal_key_name:-github_personal}
                
                # Use Git personal email if available, otherwise prompt
                local github_email=${GIT_PERSONAL_EMAIL:-""}
                if [[ -z "$github_email" ]]; then
                    echo -n "Enter your GitHub email address: "
                    read -r github_email
                else
                    note "Using Git personal email: $github_email"
                fi

                generate_ssh_key "personal" "$personal_key_name" "$github_email"

                # Save the key name for post-install notes
                export PERSONAL_SSH_KEY="$personal_key_name"
            fi

            # Work key
            echo -n "Generate a work GitHub SSH key? [y/n] "
            read -r gen_github_work

            if [[ "$gen_github_work" == "y" || "$gen_github_work" == "Y" ]]; then
                echo -n "Enter a name for this key (default: github_work): "
                read -r work_key_name
                work_key_name=${work_key_name:-github_work}
                
                # Use Git work email if available, otherwise prompt
                local work_email=${GIT_WORK_EMAIL:-""}
                if [[ -z "$work_email" ]]; then
                    echo -n "Enter your work email address: "
                    read -r work_email
                else
                    note "Using Git work email: $work_email"
                fi

                generate_ssh_key "work" "$work_key_name" "$work_email"

                # Save the key name for post-install notes
                export WORK_SSH_KEY="$work_key_name"
            fi

            # Additional key
            echo -n "Generate any additional SSH keys? [y/n] "
            read -r gen_additional

            if [[ "$gen_additional" == "y" || "$gen_additional" == "Y" ]]; then
                echo -n "Enter a name for this key: "
                read -r additional_key_name

                echo -n "Enter your email address for this key: "
                read -r additional_email

                generate_ssh_key "additional" "$additional_key_name" "$additional_email"

                # Save the key name for post-install notes
                export ADDITIONAL_SSH_KEY="$additional_key_name"
            fi

            # Update SSH config to use the new keys
            if [[ -f "$SSH_NEW_DIR/config" ]]; then
                step "Updating SSH config to use the new keys..."
                # Backup the original config
                cp "$SSH_NEW_DIR/config" "$SSH_NEW_DIR/config.backup.$(date +%Y%m%d%H%M%S)"

                # Add keys to SSH config if not already present
                if [[ -n "${PERSONAL_SSH_KEY:-}" ]] && ! grep -q "$PERSONAL_SSH_KEY" "$SSH_NEW_DIR/config"; then
                    echo "\n# Personal GitHub key" >> "$SSH_NEW_DIR/config"
                    echo "IdentityFile ~/.config/ssh/$PERSONAL_SSH_KEY" >> "$SSH_NEW_DIR/config"
                fi

                if [[ -n "${WORK_SSH_KEY:-}" ]] && ! grep -q "$WORK_SSH_KEY" "$SSH_NEW_DIR/config"; then
                    echo "\n# Work GitHub key" >> "$SSH_NEW_DIR/config"
                    echo "IdentityFile ~/.config/ssh/$WORK_SSH_KEY" >> "$SSH_NEW_DIR/config"
                fi

                if [[ -n "${ADDITIONAL_SSH_KEY:-}" ]] && ! grep -q "$ADDITIONAL_SSH_KEY" "$SSH_NEW_DIR/config"; then
                    echo "\n# Additional SSH key" >> "$SSH_NEW_DIR/config"
                    echo "IdentityFile ~/.config/ssh/$ADDITIONAL_SSH_KEY" >> "$SSH_NEW_DIR/config"
                fi

                success "SSH config updated with new keys"
            fi
        else
            warning "SSH key generation skipped"
        fi
    else
        success "Using existing SSH keys"
    fi
}

# Set up SSH configuration
setup_ssh_config() {
    header "SSH Configuration"

    # Define paths
    SSH_OLD_DIR="$HOME/.ssh"
    SSH_NEW_DIR="$HOME/.config/ssh"

    # Make sure the new SSH directory exists
    if [[ ! -d "$SSH_NEW_DIR" ]]; then
        step "Creating directory: $SSH_NEW_DIR"
        mkdir -p "$SSH_NEW_DIR"
        chmod 700 "$SSH_NEW_DIR"
    fi

    # Check if we need to migrate files
    if [[ -d "$SSH_OLD_DIR" && "$(ls -A "$SSH_OLD_DIR" 2>/dev/null)" ]]; then
        note "Found existing SSH files in $SSH_OLD_DIR"
        echo -n "Would you like to migrate SSH files to $SSH_NEW_DIR? [y/n] "
        read -r migrate_choice

        if [[ "$migrate_choice" == "y" || "$migrate_choice" == "Y" ]]; then
            step "Migrating SSH files..."

            # Create a backup of the old directory first
            cp -a "$SSH_OLD_DIR" "${SSH_OLD_DIR}.backup.$(date +%Y%m%d%H%M%S)"
            success "Created backup of $SSH_OLD_DIR"

            # Copy files with proper permissions
            cp -a "$SSH_OLD_DIR/"* "$SSH_NEW_DIR/" 2>/dev/null || true

            # Set proper permissions
            chmod 700 "$SSH_NEW_DIR"
            find "$SSH_NEW_DIR" -type f -exec chmod 600 {} \;

            # Remove old directory if migration was successful
            rm -rf "$SSH_OLD_DIR"

            success "SSH files migrated to $SSH_NEW_DIR"
            note "The original $SSH_OLD_DIR directory has been removed"
            note "Original files are preserved in $SSH_OLD_DIR.backup.*"
            note "After testing, you can remove the original with: mv $SSH_OLD_DIR $SSH_OLD_DIR.old"
        else
            warning "SSH file migration skipped"
        fi
    else
        note "No existing SSH directory or files found in $SSH_OLD_DIR"
    fi

    # Set up SSH config from template if it doesn't exist
    if [[ ! -f "$SSH_NEW_DIR/config" && -f "$SSH_NEW_DIR/config.template" ]]; then
        step "Creating SSH config from template..."
        cp "$SSH_NEW_DIR/config.template" "$SSH_NEW_DIR/config"
        chmod 600 "$SSH_NEW_DIR/config"
        success "SSH config created"
    fi

    # Create empty local config if it doesn't exist
    if [[ ! -f "$SSH_NEW_DIR/config.local" ]]; then
        step "Creating empty local SSH config..."
        echo "# Local SSH configuration - not tracked in git" > "$SSH_NEW_DIR/config.local"
        echo "# Add your sensitive or machine-specific SSH configuration here" >> "$SSH_NEW_DIR/config.local"
        chmod 600 "$SSH_NEW_DIR/config.local"
        success "Empty local SSH config created"
    fi

    # Offer to generate SSH keys if none exist
    offer_generate_keys

    success "SSH configuration completed"
}

# Run the function if script is executed directly
if [[ "${(%):-%N}" == "$0" && -z "${SOURCED_ONLY:-}" ]]; then
    setup_ssh_config
fi
