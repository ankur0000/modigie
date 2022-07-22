<aura:application controller="ModigieConfiguration" access="global" >
	<aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
	<aura:attribute name="customerId" type="String"/>
    <aura:attribute name="baseUrl" type="String"/>
</aura:application>