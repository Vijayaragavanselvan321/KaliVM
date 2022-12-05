  	provider "azurerm" {
   features {}
}
    # refer to a resource group
  	data "azurerm_resource_group" "sample" {
  	  name = "Terraformdemo"
  	}
  	
  	#refer to a subnet
  	data "azurerm_subnet" "sample" {
  	  name                 = "default"
  	  virtual_network_name = "Vnetdemo"
  	  resource_group_name  = "Terraformdemo"
  	}
  	
  	# Create public IPs
  	resource "azurerm_public_ip" "sample" {
  	    name                         = "vmkalus"
  	    location                     = "${data.azurerm_resource_group.sample.location}"
  	    resource_group_name          = "${data.azurerm_resource_group.sample.name}"
  	    allocation_method            = "Dynamic"
  	
  	}
  	
  	# create a network interface
  	resource "azurerm_network_interface" "test" {
  	  name                = "nic-test"
  	  location            = "${data.azurerm_resource_group.sample.location}"
  	  resource_group_name = "${data.azurerm_resource_group.sample.name}"
  	
  	  ip_configuration {
  	    name                          = "testconfiguration1"
  	    subnet_id                     = "${data.azurerm_subnet.sample.id}"
  	    private_ip_address_allocation = "Dynamic"
  	    public_ip_address_id          = "${azurerm_public_ip.sample.id}"
  	  }
  	}
  	
  	# Create virtual machine
  	resource "azurerm_virtual_machine" "test" {
  	    name                  = "vmkalus#"
  	    location              = "${azurerm_network_interface.test.location}"
  	    resource_group_name   = "${data.azurerm_resource_group.sample.name}"
  	    network_interface_ids = ["${azurerm_network_interface.test.id}"]
  	    vm_size               = "Standard_B2ms "
  	
  	# Uncomment this line to delete the OS disk automatically when deleting the VM
  	delete_os_disk_on_termination = true
  	
  	# Uncomment this line to delete the data disks automatically when deleting the VM
  	delete_data_disks_on_termination = true
  	
  	storage_image_reference {
  	id = " /subscriptions/93e5f67a-655f-4b84-a742-beff5ee5de6e/resourceGroups/rg-p-euw-asc-vmimages-01/providers/Microsoft.Compute/images/kali-kali-rolling-amd64-daily-20220309"
  	}
  	storage_os_disk {
  	name = "myosdisk1"
  	caching = "ReadWrite"
  	create_option = "FromImage"
  	managed_disk_type = "Standard_LRS"
  	}
  	os_profile {
  	computer_name = "hostname"
  	admin_username = "kaluser"
  	admin_password = "Password1234!"
  	}
  	os_profile_linux_config {
  	disable_password_authentication = false
  	}
  	}
