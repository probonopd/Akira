/*
* Copyright (c) 2019 Alecaddd (http://alecaddd.com)
*
* This file is part of Akira.
*
* Akira is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* Akira is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with Akira.  If not, see <https://www.gnu.org/licenses/>.
*
* Authored by: Alessandro "Alecaddd" Castellani <castellani.ale@gmail.com>
*/

public class Akira.Partials.ZoomButton : Gtk.Grid {
    public weak Akira.Window window { get; construct; }

    private Gtk.Label label_btn;
    public Gtk.Button zoom_out_button;
    public Gtk.Button zoom_default_button;
    public Gtk.Button zoom_in_button;

    public ZoomButton (Akira.Window window) {
        Object (
            window: window
        );
    }

    construct {
        get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
        get_style_context ().add_class ("linked-flat");
        valign = Gtk.Align.CENTER;
        column_homogeneous = false;
        width_request = 140;
        hexpand = false;

        zoom_out_button = new Gtk.Button.from_icon_name ("zoom-out-symbolic", Gtk.IconSize.MENU);
        zoom_out_button.clicked.connect (zoom_out);
        zoom_out_button.get_style_context ().add_class ("raised");
        zoom_out_button.get_style_context ().add_class ("button-zoom");
        zoom_out_button.can_focus = false;
        zoom_out_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>minus"}, _("Zoom Out"));

        zoom_default_button = new Gtk.Button.with_label ("100%");
        zoom_default_button.hexpand = true;
        zoom_default_button.clicked.connect (zoom_reset);
        zoom_default_button.can_focus = false;
        zoom_default_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>0"}, _("Reset Zoom"));

        zoom_in_button = new Gtk.Button.from_icon_name ("zoom-in-symbolic", Gtk.IconSize.MENU);
        zoom_in_button.clicked.connect (zoom_in);
        zoom_in_button.get_style_context ().add_class ("raised");
        zoom_in_button.get_style_context ().add_class ("button-zoom");
        zoom_in_button.can_focus = false;
        zoom_in_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>plus"}, _("Zoom In"));

        attach (zoom_out_button, 0, 0, 1, 1);
        attach (zoom_default_button, 1, 0, 1, 1);
        attach (zoom_in_button, 2, 0, 1, 1);

        label_btn = new Gtk.Label (_("Zoom"));
        label_btn.get_style_context ().add_class ("headerbar-label");
        label_btn.margin_top = 4;

        attach (label_btn, 0, 1, 3, 1);
        udpate_label ();

        settings.changed["show-label"].connect ( () => {
            udpate_label ();
        });
    }

    private void udpate_label () {
        label_btn.visible = settings.show_label;
        label_btn.no_show_all = !settings.show_label;
    }

    public void zoom_out () {
        window.event_bus.update_scale (-0.5);
    }

    public void zoom_in () {
        window.event_bus.update_scale (0.5);
    }

    public void zoom_reset () {
        zoom_in_button.sensitive = true;
        zoom_out_button.sensitive = true;

        window.event_bus.set_scale (1);
    }
}
