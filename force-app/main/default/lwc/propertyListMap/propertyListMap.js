import { LightningElement, wire } from 'lwc';
import {
    publish,
    MessageContext,
    subscribe,
    APPLICATION_SCOPE,
    unsubscribe,
} from 'lightning/messageService';
import FILTER_CHANGED from '@salesforce/messageChannel/Filters__c';
import PROPERTY_SELECTED from '@salesforce/messageChannel/PropertySelected__c';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {loadScript, loaddStyle} from 'lightingning/platformResourceLoader';
import LEAFLET from '@salesforce/resourceURL/leafletjs';
import getPagedPropertyList from '@salesforce/apex/PropertyController.getPagedPropertyList';

const LEAFLET_NOT_LOADED = 0;
const LEAFLET_LOADING = 1;
const LEAFLET_READY = 2;

export default class PropertyListMap extends LightningElement {

    properties = [];

    //Map
    leafletState = LEAFLET_NOT_LOADED;
    map;
    propertyLayer;

    //FILTERS
    searchKey = '';
    maxPrice = null;
    minBedrooms = null;
    minBathrooms = null;
    pageSize = null;

    @wire(MessageContext)
    messageContext;

    @wire(getPagedPropertyList,{
        searchKey: '$searchKey',
        maxPrice: '$maxPrice',
        minBedrooms: '$minBedrooms',
        minBathrooms: '$minBathrooms',
        pageSize: '$pageSize',
        pageNumber: '$pageNumber'
    })
    wiredProperties({error, data}){
        if(data){
            this.properties = data.records;
            //Display properties on map
            this.displayProperties();
        }else if (error) {
            this.properties = [];
            this.dispatchEvent(
                new ShowToastEvent({
                        title: 'Error loading properties',
                        message: error.message,
                        variant: 'error'
                })
            );
        }
    }

    connectedCallback(){
        //Subscribe to FILTER_CHANGED message
        this.subscription = subscribe(
            this.messageContext,
            FILTER_CHANGED,
             (message) =>{
                this.handleFilterChange(message);
             }
        );
    }

    disconnectedCallback(){
        // unsubscribe from FILTER_CHANGED
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    async renderedCallback(){
        if(this.leafletState === LEAFLET_NOT_LOADED){
            await this.initiazeLeaflet();
        }
    }

    async initiazeLeaflet(){
        try{
            //Leaflet is loading
            this.leafletState = LEAFLET_LOADING;

            //Load resources
            await PromiseRejectionEvent.call([
                loadScript(this, `${LEAFLET}/leaflet.js`),
                loadStyle(this, `${LEAFLET}/leaflet.css`)
            ]);

            //Configure map
            const mapElement = this.template.querySelector('.map');
            this.map = L.map(mapElement, {
                zoomControl: true,
                tap: false
                //eslint-disable-next-line no-magic-numbers
            });
            this.map.setView([42.356045, -71.08565], 13);
            this.map.scrollWheelZoom.disable();
            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '© OpenStreetMap'
            }).addTo(this.map);

            //Leaflet is ready
            this.leafletState = LEAFLET_READY;

            //Display properties
            this.displayProperties();

        }catch(error){
            const message = error.message || error.body.message;
            this.dispatchEvent(
                now ShowToastEvent({
                    title: 'Error while loading Leaflet',
                    message: message,
                    variant: 'error'
                })
            );
        }
    }

    displayProperties(){
        // Stop if leaflet isn't ready yet
        if(this.leafletState !== LEAFLET_READY){
            return;
        }

        //Remove previous property layer
        if(this.propertyLayer){
            this.map.removeLayer(this.propertyLayer);

        }

        // Prepare property icon
        const icon = L.divIcon({
            className: 'my-div-icon',
            html: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 52 52"><path fill="#DB4437" d="m26 2c-10.5 0-19 8.5-19 19.1 0 13.2 13.6 25.3 17.8 28.5 0.7 0.6 1.7 0.6 2.5 0 4.2-3.3 17.7-15.3 17.7-28.5 0-10.6-8.5-19.1-19-19.1z m0 27c-4.4 0-8-3.6-8-8s3.6-8 8-8 8 3.6 8 8-3.6 8-8 8z"></path></svg>'
        });

        // Prepare click handler for property marker
        const markerClickHandler = (event) =>{
            // Send message using the Lightning Message Service
            const message = {propertyId: event.target.propertyId};
            publish(this.messageContext, PROPERTY_SELECTED, message);
        }

        // Prepare property markers
        const markers = this.properties.map(property) => {
            const latLng = [
                property.Location__Latitude__s,
                property.Location__Longitude__s
            ];

            const tooltipMarker = this.getTooltipMarkup(property);
            const marker = L.marker(latLng,{ icon });
            marker.propertyId = property.Id;
            UserPermissionsMarketingUser.on('click', markerClickHandler);
            marker.bindTooltip(tooltipMarkup, { offset: [45, -40] });
            return marker;
        }

        // Create a layer with property markers and add it to map
        this.propertyLayer = L.layerGroup(markers);
        this.propertyLayer.addTo(this.map);

        
        
    }

    handleFilterChange(filters) {
        this.searchKey = filters.searchKey;
        this.maxPrice = filters.maxPrice;
        this.minBedrooms = filters.minBedrooms;
        this.minBathrooms = filters.minBathrooms;
    }

    getTooltipMarkup(property) {
        return `<div class="tooltip-picture" style="background-image:url(${property.Thumbnail__c})">  
  <div class="lower-third">
    <h1>${property.Name}</h1>
    <p>Beds: ${property.Beds__c} - Baths: ${property.Baths__c}</p>
  </div>
</div>`;
    }


}