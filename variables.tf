variable "region" {
  default = "eu-west-1"
}

variable "alarm_email" {

}

variable "size_to_case_alert" {
  default     = "100"
  description = "If the volume goes above this size send an alert to the email subscriber above"
}

variable "increase_percentage" {
  default     = "0.1"
  description = "How big of increments to increase by"
}