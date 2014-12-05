#------------------------------------------------------
=head1 NAME

=head1 SYNOPSIS

=cut
#------------------------------------------------------
    use Filesys::DfPortable;
    use strict;
#------------------------------------------------------
# null
#------------------------------------------------------
sub null {
    my ($par)=@_;


    return $par;
}
#------------------------------------------------------
# main
#------------------------------------------------------
sub main {


  my $ref = dfportable("C:\\"); # Default block size is 1, which outputs bytes
  if(defined($ref)) {
     print"Total bytes: $ref->{blocks}\n";
     print"Total bytes free: $ref->{bfree}\n";
     print"Total bytes avail to me: $ref->{bavail}\n";
     print"Total bytes used: $ref->{bused}\n";
     print"Percent full: $ref->{per}\n"
  }


  $ref = dfportable("/", 1024); # Display output in 1K blocks
  if(defined($ref)) {
     print"Total 1k blocks: $ref->{blocks}\n";
     print"Total 1k blocks free: $ref->{bfree}\n";
     print"Total 1k blocks avail to me: $ref->{bavail}\n";
     print"Total 1k blocks used: $ref->{bused}\n";
     print"Percent full: $ref->{per}\n"
  }

}
#------------------------------------------------------
$|++;
main(@ARGV);
