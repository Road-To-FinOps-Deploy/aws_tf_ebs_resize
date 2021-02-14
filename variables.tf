variable "region" {
  default = "eu-west-1"
}

variable "alarm_email" {
}

variable "bucket_name" {

}

variable "size_to_case_alert" {
  default     = "100"
  description = "If the volume goes above this size send an alert to the email subscriber above"
}

variable "increase_percentage" {
  default     = "0.1"
  description = "How big of increments to increase by"
}

variable "threshold" {
  default     = "75"
  description = "how high does the volumes utilised space need to be to trigger the alarm"
}

variable "InstanceId" {
  default     = ""
  description = "The id of the instance you wish to use"
}

variable "namespace" {
  default     = "Windows/Default"
  description = "Windows/Default for windows or System/Linux"
}

variable "metric_name" {
  default     = "FreeDiskPercentage"
  description = "FreeDiskPercentage for windows or MemoryUsed"
}


variable "WindowsInstanceId" {
  description = "The id of the instance you wish to use for windows"
  default     = "i-"
}

variable "LinuxInstanceId" {
  description = "The id of the instance you wish to use for linux"
  default     = "i-"
}