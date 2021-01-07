#This script sends email with multiple file attachments

Param (
[string]$workspace = " ",
[string]$Subject = ' '
) 
$Email       = 'Tanmay.Kolawale@2020spaces.com','Mahesh.Patil@2020spaces.com','VedPrakash.Bisen@2020spaces.com','Sayali.Dhoot@2020spaces.com','Ilyass.Saighi@2020spaces.com','Vahid.khochikar@2020spaces.com'
#$Email = 'bhushan.gosavi@2020spaces.com'
#[array]$attachments = Get-ChildItem "$workspace\External Libraries\reportsFolder" *.xlsx
[array]$attachments = Get-ChildItem "$workspace" *.txt
$Msg = @{
    to          = $Email
    from        = "qaguiautomationtest1@2020spaces.com"
    Body        = "Please find attached reports"
    subject     = "$Subject"
    smtpserver  = "mail.2020.net"
    BodyAsHtml  = $True
    Attachments = $attachments.fullname
}
Send-MailMessage @Msg