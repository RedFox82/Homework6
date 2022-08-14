document.addEventListener('DOMContentLoaded', function() {

  const amountConverters = 4;
  const converters = document.getElementsByClassName('item');
  const koefs = [0.3937007874, 0.032808399, 1.0936132983, 0.6213711922];
  const ci = ['cm', 'cm', 'm', 'km'];

  const event = new Event("change", {bubbles: true});
  const eventInc = new Event("keyup", {bubbles: true});

//Event handlers
  for (let i = 1; i <= amountConverters; i++) {
    const metricFrom = document.getElementById('metricFrom'+i);
    const metricTo = document.getElementById('metricTo'+i);
    const spanIn = document.getElementById('span-in'+i);
    const spanOut = document.getElementById('span-out'+i);
    const swp = document.getElementById('swp'+i);
    const cls = document.getElementById('cls'+i);
    const income = document.getElementById('income'+i);
    const result = document.getElementById('result'+i);    

//Change spans labels
    metricFrom.addEventListener("change", function(event) {  
      spanIn.innerHTML = this.value;
      });
    metricTo.addEventListener("change", function() {  
      spanOut.innerHTML = this.value;
    });

//Swap from-to metrics
    swp.addEventListener("click", function() {  
      let From = metricFrom.value;
      let To = metricTo.value;
      metricFrom.value = To;
      metricFrom.dispatchEvent(event);
      metricTo.value = From;
      metricTo.dispatchEvent(event);
    });    

//Clear form
    cls.addEventListener("click", function() {
      clearErrors(this);
      this.form.reset();    
      metricFrom.dispatchEvent(event);
      metricTo.dispatchEvent(event);        
    });

//Analisys input data for convertation
    income.addEventListener("keyup", function(eventInc) {  
      clearErrors(income);
      result.value = null;
      if ( (!( /^[-+]?[0-9]*[.,]?[0-9]+(?:[eE][-+]?[0-9]+)?$/.test(this.value))) && (income.value !== '') ) {        
        let error = document.createElement('div');
        error.className = 'error';
        error.style.color = 'red';
        income.style.borderColor = 'red';
        error.innerHTML = 'Please provide a valid number!';
        income.parentElement.insertBefore(error, spanIn);
      }
    });

//If delete or backspace button used
    income.addEventListener("keydown", function() {  
        income.dispatchEvent(eventInc);
    });


//Trying submit convertation
    converters[i-1].onsubmit = () => {
      dataSelector(i);
      formOnSubmit(koefs[i-1], ci[i-1]); 
      return false;
    }; 
  }


//Selector of metrics and in/out data
  function dataSelector(i) {
    metricFrom = document.getElementById('metricFrom'+i);
    metricTo = document.getElementById('metricTo'+i);
    income = document.getElementById('income'+i);
    result = document.getElementById('result'+i);
  }

//Clear errors
  function clearErrors(obj) {
    let errors = obj.form.getElementsByClassName('error');
    for (let i = 0; i < errors.length; i++) {
      errors[i].remove()
    }
    let inps = obj.form.getElementsByClassName('form-control');  
    for (let i = 0; i < inps.length; i++) {
      inps[i].style.borderColor = 'lightgrey';
    }       
  }

//Convertation metrics
  function formOnSubmit(k, ci) {
    if (formValidate(income)) {
        if(metricFrom.value !== metricTo.value) {
          if (metricFrom.value === ci) {
            result.value = Math.round(income.value * k * 100)/100;
          } else {
            result.value = Math.round(income.value * (100/k))/100;
          }
        } else {
          result.value = income.value;
        }
    }   
  }

//Validation form
  function formValidate(income) {
    let errors = income.form.getElementsByClassName('error');
    if (income.value !== '' && errors.length === 0) {
      return true;
    }
    return false;
  }

});