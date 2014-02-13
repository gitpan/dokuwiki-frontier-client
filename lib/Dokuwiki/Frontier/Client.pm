# ABSTRACT: Dokuwiki::Frontier::Client - A Frontier::Client for dokuwiki (https://www.dokuwiki.org)

package Dokuwiki::Frontier::Client;
use Moo;
extends 'Frontier::Client';

our $VERSION = '0.1';
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

THIS MODULE IS DEPRECATED.  use L<Dokuwiki::RPC::XML::Client> instead.

=cut
