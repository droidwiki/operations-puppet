# A role that ensures, that ganglia (both gmetad
# and ganglia-monitor) is installed and correctly
# configured to send the data to go2tech.de
class role::ganglia(
  Boolean $gmetad = false,
) {
  include ganglia::gmond

  if ($gmetad) {
    include ganglia::gmetad
  }
}
