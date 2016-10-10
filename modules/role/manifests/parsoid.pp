# Manages monit only for now, will manage parssoid
# in the future.
class role::parsoid {
  monit::service { 'parsoid': }
}
