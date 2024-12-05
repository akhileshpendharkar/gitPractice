import { LightningElement } from 'lwc';
import getWeather from '@salesforce/apex/WeatherApi.getWeather';

export default class WeatherApi extends LightningElement {
    city;
    imageUrl;
    condition;


    handleChange(event){
        this.city = event.target.value;
        console.log(this.city);
    }

    getWeatherBtn(){
        getWeather({ city: this.city}).then((response) =>{
            console.log('##### Response: '+response);
            let parsedData = JSON.parse(response);
            this.imageUrl = parsedData.current.condition.icon;
            this.condition = parsedData.current.condition.text;
        })
        .catch((error) =>{
            this.condition = 'City not in list';
            console.log('Error: '+ JSON.stringify(error));
        })
        .finally(() => {
            console.log('Completed!')
        })
    }
}