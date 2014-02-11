# ABSTRACT: Dokuwiki::Frontier::Client - A Frontier::Client for dokuwiki (https://www.dokuwiki.org)

package Dokuwiki::Frontier::Client;
use Moo;
extends 'Frontier::Client';

our $VERSION = '0.0';
our %API = qw<
getPagelist dokuwiki.getPagelist
getVersion dokuwiki.getVersion
getTime dokuwiki.getTime
getXMLRPCAPIVersion dokuwiki.getXMLRPCAPIVersion
login dokuwiki.login
search dokuwiki.search
getTitle dokuwiki.getTitle
appendPage dokuwiki.appendPage
setLocks dokuwiki.setLocks
getRPCVersionSupported wiki.getRPCVersionSupported
aclCheck wiki.aclCheck
getPage wiki.getPage
getPageVersion wiki.getPageVersion
getPageVersions wiki.getPageVersions
getPageInfo wiki.getPageInfo
getPageInfoVersion wiki.getPageInfoVersion
getPageHTML wiki.getPageHTML
getPageHTMLVersion wiki.getPageHTMLVersion
putPage wiki.putPage
listLinks wiki.listLinks
getAllPages wiki.getAllPages
getBackLinks wiki.getBackLinks
getRecentChanges wiki.getRecentChanges
getRecentMediaChanges wiki.getRecentMediaChanges
getAttachments wiki.getAttachments
getAttachment wiki.getAttachment
getAttachmentInfo wiki.getAttachmentInfo
putAttachment wiki.putAttachment
deleteAttachment wiki.deleteAttachment
addAcl plugin.acl.addAcl
delAcl plugin.acl.delAcl >; 

sub base {
    my $class = shift;
    my %p = do {
        @_ % 2
        ? ( url => @_ )
        : @_
    };

    $p{url}.='lib/exe/xmlrpc.php';
    $class->new( %p );
}

{ no strict 'refs';
    while ( my($method, $call) = each %API ) {
        *{__PACKAGE__."::$method"} = sub {
            my $client = shift;
            $client->call( $call, @_ )
        }
    }
};

1;


=head1 NAME

Dokuwiki::Frontier::Client - A Frontier::Client for L<dokuwiki|https://www.dokuwiki.org>.

=head1 SYNOPSIS

L<Dokuwiki::Frontier::Client> extends the L<Frontier::Client> with the Dokuwiki
XML-RPC methods (without namespace) described in the
L<dokuwiki xml-rpc page|https://www.dokuwiki.org/devel:xmlrpc>.

so the call to the
L<wiki.getAllPages|https://www.dokuwiki.org/devel:xmlrpc#wikigetallpages>
(which also require a call to
L<dokuwiki.login|https://www.dokuwiki.org/devel:xmlrpc#dokuwikilogin>)
is like:

    use Dokuwiki::Frontier::Client;
    use YAML ();

    my $client = Dokuwiki::Frontier::Client->base('https://di.u-strasbg.fr/')
        or die;

    $client->login('editor','s3cr3t')
        or die; 

    print YAML::Dump [ $client->getAllPages ];

=head1 CONSTRUCTORS

Note that C<base> is just a shortcut for C<new>. those constructions are equivalent:

    Dokuwiki::Frontier::Client->base('https://di.u-strasbg.fr/');
    Dokuwiki::Frontier::Client->base(url => 'https://di.u-strasbg.fr/');
    Dokuwiki::Frontier::Client->new(url => 'https://di.u-strasbg.fr/lib/exe/xmlrpc.php' );

=head1 METHODS, INTROSPECTION

C<%Dokuwiki::Frontier::Client::API> is a hash where keys are the
C<Dokuwiki::Frontier::Client> methods and values are the Dokuwiki XML-RPC
methods. So you can have the list of the mapped functions with:

    perl -MDokuwiki::Frontier::Client -E'say for keys %Dokuwiki::Frontier::Client::API'

but please refer to the 
L<dokuwiki xml-rpc page|https://www.dokuwiki.org/devel:xmlrpc> for more details.

=head1 A REAL WORLD EXAMPLE

    use Dokuwiki::Frontier::Client;
    use Modern::Perl;
    use Net::Netrc;
    use YAML;

    my $base = 'https://example.com/';
    my $host = 'server.example.com';

    my $wiki = Dokuwiki::Frontier::Client->base
        ( $host , debug => 1 );

    my $credentials = Net::Netrc->lookup($host)
        or die "please add a fake $host machine in your ~/.netrc";

    $wiki->login( ($credentials->lpa)[0,1] )
        or die "can't authenticate";

    say YAML::Dump [$wiki->getPage('/ficheappli/start')]; 

=cut
