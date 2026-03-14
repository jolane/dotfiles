take() {
  mkdir -p "$1" && cd "$1"
}

sql() {
  op run --env-file="$XDG_CONFIG_HOME/lazysql/.env" -- lazysql
}
