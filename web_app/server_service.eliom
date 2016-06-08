(* Graffiti
 * http://www.ocsigen.org/graffiti
 * Copyright (C) 2013 Arnaud Parant
 * Laboratoire PPS - CNRS Université Paris Diderot
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

module My_app =
  Eliom_registration.App (struct
    let application_name = "graffiti"
    let global_data_path = None
  end)

let main_service =
  Eliom_service.create
    ~id:(Eliom_service.Path [""])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let setting_replay_service =
  Eliom_service.create
    ~id:(Eliom_service.Path ["replay"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let start_replay_service =
  Eliom_service.create
    ~name:"start_replay"
    ~id:(Eliom_service.Fallback setting_replay_service)
    ~meth:(
      Eliom_service.Post (
        Eliom_parameter.unit,
        Eliom_parameter.(string "start_d" ** string "start_t" **
			 string "end_d" ** string "end_t" **
			 int "coef_to_replay" ** opt (int "hts"))))
    ()
