// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import {application} from "./application"

import HelloController from "./hello_controller"
import LocationController from "./location_controller";
import Select2 from "./select2_controller"

application.register("select2", Select2)
application.register("location", LocationController)
application.register("hello", HelloController)
