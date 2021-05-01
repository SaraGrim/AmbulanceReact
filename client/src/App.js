// In App.js in a new project
import React, { useState } from 'react';
import Web3 from 'web3';
import './App.css';
const web3 = new Web3(Web3.givenProvider);
import { addHospital, removeHospital, removePolice, addPolice, addAmbulance, removeAmbulance,
    verifyDelivery, postBounty, reclaimBounty, bid, revealBid} from './Handler/SolidityHandler'

import 'react-gesture-handler';
import * as React from 'react';
import { NavigationContainer } from '@react-navigation';
import { createStackNavigator } from '@react-navigation/stack';
import LoginScreen from './LoginScreen.js';
import PoliceMainScreen from './PoliceMainScreen';
import PoliceDetailedScreen from './PoliceDetailedScreen.js';
import AmbulanceMainScreen from './AmbulanceMainScreen.js';
import AmbulanceDetailedScreen from './AmbulanceDetailedScreen.js';
import HospitalMainScreen from './HospitalMainScreen.js';
import HospitalDetailedScreen from './HospitalDetailedScreen.js';
import AdminMainScreen from './AdminMainScreen.js';

const Stack = createStackNavigator();

function App() {
    return (
        <NavigationContainer>
            <Stack.Navigator>
                <Stack.Screen name="Login Page" component={LoginScreen} />
                <Stack.Screen name="Police Home Page" component={PoliceMainScreen} />
                <Stack.Screen name="Police Detailed Page" component={PoliceDetailedScreen} />
                <Stack.Screen name="Ambulance Home Page" component={AmbulanceMainScreen} />
                <Stack.Screen name="Ambulance Detailed Page" component={AmbulanceDetailedScreen} />
                <Stack.Screen name="Hospital Home Page" component={HospitalMainScreen} />
                <Stack.Screen name="Hospital Detailed Page" component={HospitalDetailedScreen} />
                <Stack.Screen name="Admin Home Page" component={AdminMainScreen} />
            </Stack.Navigator>
        </NavigationContainer>
    );
}

export default App;