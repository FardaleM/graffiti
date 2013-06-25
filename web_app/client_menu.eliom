
{client{

  open Lwt

  (** Handle client menu action **)
  let start body_elt header_elt save_elt save_link_elt save_div_elt
      about_point gray_layer_elt about_elt =

    (*** Elements ***)
    let dom_about_point = Eliom_content.Html5.To_dom.of_span about_point in
    let dom_gray_layer = Eliom_content.Html5.To_dom.of_div gray_layer_elt in
    let dom_save = Eliom_content.Html5.To_dom.of_div save_elt in
    let dom_save_link = Eliom_content.Html5.To_dom.of_a save_link_elt in
    let dom_save_div = Eliom_content.Html5.To_dom.of_div save_div_elt in
    let dom_about = Eliom_content.Html5.To_dom.of_div about_elt in

    (* on about  *)
    Lwt.async (fun () -> Lwt_js_events.clicks dom_about_point
      (fun _ _ -> Lwt.return (Client_menu_tools.switch_fullscreen_display
                                dom_gray_layer dom_about)));

    (* on save button *)
    (* active contract/expand only on small screen *)
    let save_click () =

      let rec disable_id = ref
	(Client_tools.disable_event Dom_html.Event.click dom_save_link)
      and contract () =
	dom_save##style##width <- Js.string "30px";
	dom_save_div##style##width <- Js.string "13px";
	disable_id := Client_tools.disable_event
          Dom_html.Event.click dom_save_link;
	Lwt.return ()
      and expand () =
	dom_save##style##width <- Js.string "60px";
	dom_save_div##style##width <- Js.string "26px";
	Client_tools.enable_event !disable_id;
	lwt _ = Lwt_js.sleep 2. in
        contract ()
      in

      Lwt.async (fun () -> Lwt_js_events.clicks dom_save
	(fun _ _ ->
          match (Js.to_string dom_save##style##width) with
            | "60px"      -> contract ()
            | _           -> expand ()
	))
    in Client_mobile.launch_func_only_on_small_screen save_click

}}
