# Manages kibana and the kibana nginx host
class role::kibana {
  include kibana4
  include role::nginx::kibana_go2tech
}
