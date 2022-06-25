### Notes
* Zsh config contains variable `$BREW_PREFIX_PATH` that is generated one time using `$(brew --prefix)`. The steps listed below use `$BREW_PREFIX_PATH` instead of `$(brew --prefix)`. If varibale not set, use `$(brew --prefix)`

#### fzf
* To install useful keybindings and fuzzy completion:
  ```sh
  source $BREW_PREFIX_PATH/opt/fzf/install
  ```

#### gnu-sed
* GNU "sed" has been installed as "gsed".
If you need to use it as "sed", you can add a "gnubin" directory
to your PATH from your bashrc like:
  <!-- Currently not set on my machine - using gsed command -->
  ```sh
  PATH=$BREW_PREFIX_PATH/opt/gnu-sed/libexec/gnubin:$PATH
  ```

#### gnutls
* If you are going to use the Guile bindings you will need to add the following
to your .bashrc or equivalent in order for Guile to find the TLS certificates
database:
  ```sh
  export GUILE_TLS_CERTIFICATE_DIRECTORY=$(brew --prefix)/etc/gnutls/
  ```

#### mysql
* We've installed your MySQL database without a root password. To secure it run:
  ```sh
  mysql_secure_installation
  ```
* MySQL is configured to only allow connections from localhost by default. To connect run:
  ```sh
  mysql -uroot
  ```

#### openssl@1.1
* A CA file has been bootstrapped using certificates from the system
keychain. To add additional certificates, place .pem files in
  ```sh
  $BREW_PREFIX_PATH/etc/openssl@1.1/certs
  ```
  and run
  ```sh
  $BREW_PREFIX_PATH/opt/openssl@1.1/bin/c_rehash
  ```

#### postgresql
* To migrate existing data from a previous major version of PostgreSQL run:
  ```sh
  brew postgresql-upgrade-database
  ```
* This formula has created a default database cluster with:
  ```sh
  initdb --locale=C -E UTF-8 $(brew --prefix)/var/postgres
  ```
* For more details, [read the following](https://www.postgresql.org/docs/14/app-initdb.html)

#### ruby-build
* ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and these are never upgraded.
* To link Rubies to Homebrew's OpenSSL 1.1 (which is upgraded) add the following
to your /Users/runner/.bash_profile:
  ```sh
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
  ```
* Note: this may interfere with building old versions of Ruby (e.g <2.4) that use
OpenSSL <1.1.

#### zsh-autosuggestions
* To activate the autosuggestions, add the following at the end of your .zshrc:
  ```sh
  source $BREW_PREFIX_PATH/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ```

#### zsh-syntax-highlighting
* To activate the syntax highlighting, add the following at the end of your .zshrc:
  ```sh
  source $BREW_PREFIX_PATH/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ```
* If you receive "highlighters directory not found" error message,
you may need to add the following to your .zshenv:
  ```sh
  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$BREW_PREFIX_PATH/share/zsh-syntax-highlighting/highlighters
  ```
