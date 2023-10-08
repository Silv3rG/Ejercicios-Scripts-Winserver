#Importa la información de los dos documentos.

$empleados = import-CSV C:\Users\Administrador\Desktop\empleados.csv -Delimiter ";"
$departamentos = import-CSV C:\Users\Administrador\Desktop\departamentos.csv -Delimiter ";"

#Crea la UO Empresa y las UO de los distintos departamentos

New-ADOrganizationalUnit -Name "Empresa" -Path "DC=EMPRESA,DC=LOCAL"

foreach($dep in $departamentos){
 
 New-ADOrganizationalUnit -Name $($dep.departamento) -Path "OU=EMPRESA,DC=EMPRESA,DC=LOCAL" -Description "$($dep.descripcion)"

}



#Crea los grupos para cada UO de los departamentos.

foreach($dep in $departamentos){

New-ADGroup -Name $($dep.departamento) -GroupCategory Security -GroupScope Global -Path "OU=$($dep.departamento),OU=EMPRESA,DC=EMPRESA,DC=LOCAL"
}


#Crea los usuarios y los añade al grupo de cada departamento

foreach($em in $empleados){
New-ADUser -Name "$($em.nombre) $($em.apellido)" -Path "OU=$($EM.departamento),OU=EMPRESA,DC=EMPRESA,DC=LOCAL" -SamAccountName "$($em.nombre).$($em.apellido)" -UserPrincipalName "$($em.nombre)@empresa.local" -AccountPassword (ConvertTo-SecureString "aso2021." -AsPlainText -Force) -GivenName "$($em.nombre)" -Surname "Garcia" -ChangePasswordAtLogon $true -Enabled $true
Add-ADGroupMember -Identity "$($em.departamento)" -Members "$($em.nombre).$($em.apellido)"
}
