import numpy as np
import streamlit as st
import pickle
import sklearn 
import pandas as pd 

loaded_model = pickle.load(open('data/trained_model.sav', 'rb'))

def diabetes_prediction(input_data):
    

    
    input_data_as_numpy_array = np.asarray(input_data)

    
    input_data_reshaped = input_data_as_numpy_array.reshape(1,-1)

    prediction = loaded_model.predict(input_data_reshaped)
    print(prediction)

    if (prediction[0] == 0):
      return 'The person does not have stroke'
    else:
      return 'The person has stroke'
    
def main():
    
    # 'avg_glucose_level','bmi','age'
    
    # giving a title
    st.title('Stroke prediction app')
    
    
    # getting the input data from the user
    
    
    avg_glucose_level = st.text_input('Average glucose level')
    BMI = st.text_input('BMI')
    Age = st.text_input('Age')
    
    
    # code for Prediction
    diagnosis = ''
    
    # creating a button for Prediction
    
    if st.button('Diabetes Test Result'):
        diagnosis = diabetes_prediction([avg_glucose_level, BMI, Age])
        
        
    st.success(diagnosis)
    
    
    
    
    
if __name__ == '__main__':
    main()
    