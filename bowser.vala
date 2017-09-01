// ' valac --vapidir=. --pkg gtk+-3.0 --pkg webkit2gtk-4.0 --pkg granite --thread bowser.vala ' to compile 
using Gtk;
using WebKit;
using Granite.Widgets;

public class Bowser : Granite.Application {
    private Window window;
    private Entry urlbar;
    private WebView web_view;
    
    private Regex protocol_regex;
    private Regex stuf_regex;
    
    private const string DEFAULT_PROTOCOL = "http";

    construct {
        application_id = "com.github.lordyovz.bowser";
        flags = ApplicationFlags.FLAGS_NONE;

        program_name = "Bowser";
        
        build_version = "0.1";
        main_url = "https://github.com/lordyovz/bowser";
        bug_url = "https://github.com/lordyovz/bowser/issues";
        help_url = "https://github.com/lordyovz/bowser/issues";

        about_documenters = { "Mehmet Yavuz Uzun <memtyovz@gmail.com>" };
        about_artists = { "Mehmet Yavuz Uzun <memtyovz@gmail.com>" };
        about_authors = {
            "Mehmet Yavuz Uzun <memtyovz@gmail.com>",

        };

        about_comments = "A minimal browser powered by Webkit";
        about_license_type = Gtk.License.GPL_3_0;
    }

    public override void activate () {
        var window = new Gtk.Window ();

        var headerbar = new Gtk.HeaderBar ();
        headerbar.show_close_button = true;
        urlbar = new Gtk.Entry();
        urlbar.set_width_chars(50);
        headerbar.set_custom_title(urlbar);
		var prevbutton = new Button.from_icon_name ("go-previous", Gtk.IconSize.LARGE_TOOLBAR);
		headerbar.pack_start (prevbutton);
		prevbutton.clicked.connect (() => {
			web_view.go_back();
		});

		var nextbutton = new Button.from_icon_name ("go-next", Gtk.IconSize.LARGE_TOOLBAR);
		headerbar.pack_start (nextbutton);
		nextbutton.clicked.connect (() => {
			web_view.go_forward();
		});

		var relobutton = new Button.from_icon_name ("view-refresh", Gtk.IconSize.LARGE_TOOLBAR);
		headerbar.add (relobutton);
		relobutton.clicked.connect (() => {
			web_view.reload();
		});

		var homebutton = new Button.from_icon_name ("go-home", Gtk.IconSize.LARGE_TOOLBAR);
		headerbar.add (homebutton);
		homebutton.clicked.connect (() => {
			web_view.load_uri("https://www.porcay.com/ana");
		});



        var web_view = new WebView ();


        urlbar.set_placeholder_text ("...");
        this.web_view = new WebView ();
        window.add (this.web_view);
        var primary_color_button = new Gtk.ColorButton.with_rgba ({ 255, 255, 255, 255 });
        Granite.Widgets.Utils.set_color_primary (window, primary_color_button.rgba);
        window.set_default_size (900, 650);
        window.set_titlebar (headerbar);
        window.title = "Bowser";
        window.show_all ();
        this.web_view.load_uri("https://www.porcay.com/ana");
        try {
            this.protocol_regex = new Regex (".*://.*");
        } catch (RegexError e) {
            critical ("%s", e.message);
        }
        try {
            this.stuf_regex = new Regex (".*..*");
        } catch (RegexError e) {
            critical ("%s", e.message);
        }

        connect_signals ();
        this.urlbar.grab_focus ();

        add_window (window);     
        
    }

    private void connect_signals () {
        window.destroy.connect (Gtk.main_quit);
        urlbar.activate.connect (on_activate);
        this.web_view.load_changed.connect ((source, frame) => {
            this.urlbar.text = web_view.get_uri ();
        });
    }


    private void on_activate () {
        var url = this.urlbar.text;
        if (!this.protocol_regex.match (url)) {
            url = "%s://%s".printf (Bowser.DEFAULT_PROTOCOL, url);
        }
        web_view.load_uri (url);
	}

    public static int main (string[] args) {
        var application = new Bowser ();
        return application.run (args);
    }
}
