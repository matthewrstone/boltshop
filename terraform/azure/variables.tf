variable "cidr" {
    description = "The CIDR block (0.0.0.0/0) for the VPC."
    default = "10.253.252.0/24"
}
variable "howmany" {
    description = "The number of instances to build."
    default = 2
}
variable "location" {
    description = "The Azure location to build in."
    default = "centralus"
}