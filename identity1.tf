provider "oci" {
  tenancy_ocid ="${var.tenancy_ocid}"
  region       = "${var.region}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
}

variable "tenancy_ocid"{
    default= "ocid1.tenancy.oc1..aaaaaaaasa5sqqw5dwqprvnno3wgm3ekbmfujudimoxg5xi55d36w5fegyka"
}
variable "region"{
    default="eu-frankfurt-1"
}

variable "user_ocid"{
    default="ocid1.user.oc1..aaaaaaaa2oh6k3kezgfsgpho7rqndol6gdpt4vdgr4ii7mnpvas5sevfhr4a"
}

variable "fingerprint"{
    default="2c:15:77:7c:b0:2c:53:00:44:ab:1b:8f:6b:43:31:1a"
}

variable "private_key_path" {
    default="oci_api_key.pem"
}

variable "compartment_id"{

    default="ocid1.compartment.oc1..aaaaaaaaw7pbuaonr7n7xk367vnlk4qzrp2jezzp5ivcgpnfle5qtmxmkkyq"
}

resource "oci_identity_compartment" "compartment1" {
    name="TF-example-compartment-new"
    description=" our new compartment"

}
output "show_compartment" {

    value=oci_identity_compartment.compartment1.compartment_id
}

resource "oci_identity_user" "user1"{
    name="tf-example-User1"
    description="This is new user"
    email="vijay.mumbai1984@gmail.com"
}

output "show_user"{
    value=oci_identity_user.user1.name
}

resource "oci_identity_ui_password" "password1"{
    user_id=oci_identity_user.user1.id
}

output "show_user_password"{
    sensitive=false
    value=oci_identity_ui_password.password1.password
}

resource "oci_identity_group" "group1"{
    name="tf-example-group"
    description="our new group"
}

resource "oci_identity_user_group_membership" "test_user_group_membership"{
    group_id=oci_identity_group.group1.id
    user_id=oci_identity_user.user1.id
}

data "oci_identity_groups" "groups1" {
    compartment_id=oci_identity_compartment.compartment1.compartment_id
    filter {
        name="name"
        values=["tf-example-group1"]

    }
}

output "groups"{
    value=data.oci_identity_groups.groups1.groups
}

resource "oci_identity_policy" "policy1" {
    compartment_id=oci_identity_compartment.compartment1.compartment_id
    description="This is new policy1"
    name="tf_example_policy1"
    statements=[
    "Allow group ${oci_identity_group.group1.name} to  read  isntances in compartment ${oci_identity_compartment.compartment1.name}", 
    "Allow group ${oci_identity_group.group1.name} to inspect instances in compartment ${oci_identity_compartment.compartment1.name}"
    ]
}

output "policy"{
    value=oci_identity_policy.policy1.name
}

output "policy_statement"{

    value=oci_identity_policy.policy1.statements
}
