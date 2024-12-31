import requests
from flight_search import FlightSearch

class DataManager:
    #This class is responsible for talking to the Google Sheet.
    
    def __init__(self):
        self.sheety_data = []
        self.sheety_dict={}
        self.SHEETY_ENDPOINT = "https://api.sheety.co/a0d82131776d41e5ab3537f55dee7f5d/flightDeals/prices"
        TOKEN = "a;wlrkjf3wq[app;'';rkfq[p'akfr[p"
        self.SHEETY_HEADERS = {"Authorization": f"Bearer {TOKEN}"}

    def get_sheet_data(self):
        self.sheet_content = requests.get(url=self.SHEETY_ENDPOINT, headers=self.SHEETY_HEADERS).json()

        for row in self.sheet_content['prices']:
            self.sheety_dict={}
            self.sheety_dict["sheety_price"] = row.get("lowestPrice")
            self.sheety_dict["to_city"] = row.get("city")
            self.sheety_dict["to_city_iata"] = row.get("iataCode")
            self.sheety_data.append(self.sheety_dict)
            # self.sheety_dict[to_city] = sheety_price 
        return self.sheety_data

    def get_cities(self):
        self.update_endpoint = "https://api.sheety.co/a0d82131776d41e5ab3537f55dee7f5d/flightDeals/prices"
        self.sheet_content = requests.get(url=self.update_endpoint, headers=self.SHEETY_HEADERS).json()
        destination_data = self.sheet_content["prices"] 
        return destination_data

    def update_sheety(self):
        for row in self.get_cities():
            new_data = {"price" : {"iataCode" : FlightSearch().get_city_code((row["city"]))}}
    
            response = requests.put(url=f"{self.update_endpoint}/{row['id']}", json=new_data, headers = self.SHEETY_HEADERS)
            print(response.text)
            