//<script>
"use strict";

function _instanceof(left, right) { if (right != null && typeof Symbol !== "undefined" && right[Symbol.hasInstance]) { return right[Symbol.hasInstance](left); } else { return left instanceof right; } }

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

//当前版本 v1.0     
//更新日期：2019-05-30

/*******************************************参数说明**********************************************************/
//            var measureValues = parameter.measureValues;//测量值
//            var designValues = parameter.designValues;//设计值
//            var maxValues = parameter.maxValues;//标准最大值
//            var minValues = parameter.minValues;//标准最小值
//            var limitValues = parameter.limitValues;//爆版值
//            var measurePoint = parameter.measurePoint;//算出一个结果点需要的测量值个数

/******************************************新增算法步骤<必看>**************************************************/
//    除了增加算法本体外，需要同时修改方法  (shouldReplaceDotForMethod)和(shouldHaveDesginValueForparameter)

/***********************************************************************************************************/

//当前版本 v1.1    
//更新日期：2019-06-11
//更新了开间进深类指标输入.无法显示未检测的问题
//增加了单算法function里旧实测值替换.之后个数为0的情况判断
/*******************************************更新说明**********************************************************/

//当前版本 v1.2    
//更新日期：2019-06-25
//修复多控算法返回错误的问题
/*******************************************更新说明**********************************************************/

var dotResult = "9";
var illegalResult = "8"; //无此算法

var illegalMeasureValues = "7"; //非法测量值
//启动函数

function getResultForArguments(parameter) {
  var methods = parameter.methods;
  var methodsArr = methods.split(";");
  var measureValues = parameter.measureValues;
  var measureArray = measureValues.split(";");
  var designValues = parameter.designValues;
  var designArr = new Array();

  if (designValues.length > 0) {
    designArr = designValues.split(";");
  }

  var type = Object.prototype.toString.call(methodsArr);

  if (type == "[object Array]") {
    var mCounts = count(methodsArr);
    var dCounts = count(designArr);
    var resultsArray = new Array();

    for (var i = 0; i < mCounts; i++) {
      var result = "";

      if (dCounts == 0) {
        result = singleMethodCaculator(methodsArr[i], 0, 0, parameter);
      } else {
        var str = "";

        for (var j = 0; j < dCounts; j++) {
          var newMeasureArray = new Array();

          for (var b = 0; b < parameter.measurePoint; b++) {
            var index = parameter.measurePoint * j + b;
            var resStr = measureArray[index];
            newMeasureArray.push(resStr);
          }

          var newParameter = clone(parameter);
          newParameter.measureValues = transArrayToStr(newMeasureArray);
          str = singleMethodCaculator(methodsArr[i], i, j, newParameter);

          if (result.length == 0) {
            result = str;
          } else {
            result += ";" + str;
          }
        }
      }

      if (methodsArr[i] == "23") {
        var singleResArr = result.split(";");

        for (var singleRes = 0; singleRes < count(singleResArr); singleRes++) {
          if (singleResArr[singleRes] == "1") {
            var specailRes = "";

            for (var specailIdx = 0; specailIdx < count(singleResArr); specailIdx++) {
              if (specailRes.length == 0) {
                specailRes = "1";
              } else {
                specailRes += ";" + "1";
              }
            }

            result = specailRes;
            break;
          }
        }
      }

      resultsArray.push(result);
    }

    if (count(resultsArray) == 1) {
      return resultsArray[0];
    } else if (count(resultsArray) == 2) {
      return processFinalResultForDoubleArray(resultsArray[0], resultsArray[1]);
    } else if (count(resultsArray) == 3) {
      return processFinalResultForTribleArray(resultsArray);
    }

    return "参数有误";
  }
} //双控算法结果点


function processFinalResultForDoubleArray(resultStr1, resultStr2) {
  var res1 = resultStr1.split(";");
  var res2 = resultStr2.split(";");
  var moreArray = count(res1) >= count(res2) ? res1 : res2;
  var lessArray = count(res1) < count(res2) ? res1 : res2;
  var final = "";

  for (var idx in moreArray) {
    var group = count(moreArray) / count(lessArray);
    var str2 = lessArray[idx / group];
    var code = "0";
    var obj = moreArray[idx]; //先判断是否有输入.的情况

    if (obj == dotResult || str2 == dotResult) {
      code = dotResult;
    } else if (obj == illegalResult || str2 == illegalResult) {
      code = illegalResult;
    } else if (obj == "1" || str2 == "1") {
      code = "1";
    } else if (obj == "0" && str2 == "0") {
      code = "0";
    }

    if (final.length > 0) {
      final += ";" + code;
    } else {
      final = code;
    }
  }

  return final;
} //三控算法处理


function processFinalResultForTribleArray(resultArray) {
  var str1 = resultArray[0];
  var str2 = resultArray[1];
  var str3 = resultArray[2];
  var res1 = str1.split(";");
  var res2 = str2.split(";");
  var res3 = str3.split(";");
  var mutaArray = new Array();
  mutaArray.push(res1);
  mutaArray.push(res2);
  mutaArray.push(res3);
  mutaArray.sort(sortArray);
  var resArr = "";
  var newResult1 = "";

  for (var i = 0; i < count(mutaArray); i++) {
    if (resArr.length == 0) {
      newResult1 = processFinalResultForDoubleArray(transArrayToStr(mutaArray[i]), transArrayToStr(mutaArray[i + 1]));
      resArr = newResult1.split(";");
    } else {
      var str = processFinalResultForDoubleArray(transArrayToStr(resArr), transArrayToStr(mutaArray[i]));
      resArr = str.split(";");

      if (i == count(mutaArray) - 1) {
        return str;
      }
    }
  }

  return illegalResult;
} //单算法执行


function singleMethodCaculator(method, methodIdx, designIdx, parameter) {
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var maxValuesArr = maxValues.split(";");
  var minValuesArr = minValues.split(";");
  var designValuesArr = designValues.split(";");
  var newParameter = clone(parameter);
  newParameter.maxValues = maxValuesArr[methodIdx];
  newParameter.minValues = minValuesArr[methodIdx]; //不是所有的算法都可以移除"." 返回结果点数大于1个的不能移除

  var measureArray = newParameter.measureValues.split(";");

  if (shouldReplaceDotForMethod(method)) {
    var newMeasureArray = new Array();

    for (var idx in measureArray) {
      if (measureArray[idx] != ".") {
        newMeasureArray.push(measureArray[idx]);
      }
    }
if (count(newMeasureArray) == 0)
{
    newParameter.measureValues = transArrayToStr(measureArray);
}
else
{
	    newParameter.measureValues = transArrayToStr(newMeasureArray);
}
  } //每个算法的设计值都进行拆分


  if (count(designValuesArr) != 0) {
    newParameter.designValues = designValuesArr[designIdx];
  }

  var str = "method" + method;
  return String(eval(str + "(newParameter)"));
} //按照测量点个数返回结果点数的算法</必看>


function shouldReplaceDotForMethod(method) {
  if (method == "3" || method == "8" || method == "15" || method == "17") {
    return false;
  }

  return true;
}

function shouldHaveDesginValueForArguments(parameter) {
  var method = parameter.method;

  if (method == "1" || method == "4" || method == "8" || method == "11" || method == "12" || method == "13" || method == "14" || method == "15" || method == "16" || method == "18" || method == "19" || method == "20" || method == "21" || method == "22" || method == "23") {
    return true;
  }

  return false;
} //各算法


function method1(parameter) {
  var measureValues = parameter.measureValues;
  var designValues = parameter.designValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var measureArray = measureValues.split(";");
  var allDot = true;

  for (var idx in measureArray) {
    var value = measureArray[idx];

    if (value != ".") {
      allDot = false;
      var difference = parseFloat(value) - designValues;

      if (parseFloat(difference) < minValues || parseFloat(difference) > maxValues) {
        return 1;
      }
    }
  }

  if (allDot == true) {
    return 9;
  }

  return 0;
}

function method2(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var measureArray = measureValues.split(";");

  for (var idx in measureArray) {
    if (measureArray[idx] == ".") {
      return 9;
    }
  }

  var value1 = measureArray[0];

  if (parseFloat(value1) < minValues || parseFloat(value1) > maxValues) {
    return 1;
  } else return 0;
}

function method3(parameter) {
  var results = "";
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var limitValues = parameter.limitValues;
  var measureArray = measureValues.split(";");

  if (limitValues == 0) {
    limitValues = Number.MAX_VALUE;
  }

  var min = Number.MAX_VALUE;

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var value = parseFloat(measureArray[idx]);
      min = min < value ? min : value;
    }
  }

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var difference = parseFloat(measureArray[idx]) - min;

      if (difference > sortNum(limitValues)) {
        results = "";

        for (var i = 0; i < count(measureArray); i++) {
          if (results.length == 0) {
            results = "1";
          } else results += ";1";
        }

        return results;
      } else {
        if (difference < minValues || difference > maxValues) {
          if (results.length == 0) {
            results = "1";
          } else results += ";1";
        } else {
          if (results.length == 0) {
            results = "0";
          } else results += ";0";
        }
      }
    } else {
      if (results.length == 0) {
        results = "9";
      } else results += ";9";
    }
  }

  return results;
}

function method4(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  for (var idx in measureArray) {
    if (measureArray[idx] == ".") {
      return 9;
    }
  }

  var value1 = measureArray[0];

  if (parseFloat(value1) - designValues < minValues || parseFloat(value1) - designValues > maxValues) {
    return 1;
  } else return 0;
}

function method5(parameter) {
  var measureValues = parameter.measureValues;
  var measureArray = measureValues.split(";");
  return measureArray[0];
}

function method6(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var measureArray = measureValues.split(";");
  var min = measureArray[0];
  var max = measureArray[0];
  ;

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var value = parseFloat(measureArray[idx]);
      min = min < value ? min : value;
      max = max > value ? max : value;
    }
  }

  var difference = max - min;

  if (difference < minValues || difference > maxValues) {
    return 1;
  }

  return 0;
}

function method7(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var measureArray = measureValues.split(";");
  var min = measureArray[0];
  var max = measureArray[0];

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var value = parseFloat(measureArray[idx]);
      min = min < value ? min : value;
      max = max > value ? max : value;
    }
  }

  var difference = max - min;

  if (difference < minValues || difference > maxValues) {
    return 1;
  }

  return 0;
}

function method8(parameter) {
  var results = "";
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var limitValues = parameter.limitValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  if (limitValues == 0) {
    limitValues = Number.MAX_VALUE;
  }

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var difference = parseFloat(measureArray[idx]) - parseFloat(designValues);

      if (Math.abs(difference) > sortNum(limitValues)) {
        results = "";

        for (var i = 0; i < count(measureArray); i++) {
          if (results.length == 0) {
            results = "1";
          } else results += ";1";
        }

        return results;
      } else {
        if (difference < minValues || difference > maxValues) {
          if (results.length == 0) {
            results = "1";
          } else results += ";1";
        } else {
          if (results.length == 0) {
            results = "0";
          } else results += ";0";
        }
      }
    } else {
      if (results.length == 0) {
        results = "9";
      } else results += ";9";
    }
  }

  return results;
}

function method9(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var measureArray = measureValues.split(";");
  var min = measureArray[0];
  var max = measureArray[0];

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var value = parseFloat(measureArray[idx]);
      min = min < value ? min : value;
      max = max > value ? max : value;
    }
  }

  var difference = max - min;

  if (difference < minValues || difference > maxValues) {
    return 1;
  }

  return 0;
}

function method10(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var measureArray = measureValues.split(";");
  var max = 0;

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var value = parseFloat(measureArray[idx]);
      max = max > value ? max : value;
    }
  }

  if (max < parseFloat(minValues) || max > parseFloat(maxValues)) {
    return 1;
  } else {
    return 0;
  }
}

function method11(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var difference = parseFloat(measureArray[idx]) - parseFloat(designValues);

      if (difference < parseFloat(minValues) || difference > parseFloat(maxValues)) {
        return 1;
      }
    }
  }

  return 0;
}

function method12(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var difference = parseFloat(measureArray[idx]) - parseFloat(designValues);

      if (difference < parseFloat(minValues) || difference > parseFloat(maxValues)) {
        return 1;
      }
    }
  }

  return 0;
}

function method14(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  if (count(measureArray) > 1) {
    for (var i = 0; i < count(measureArray) - 1; i++) {
      var leftValue = parseFloat(measureArray[i]);
      var rightValue = parseFloat(measureArray[i + 1]);
      var difference = rightValue - leftValue;
      var designDifference = difference - parseFloat(designValues);

      if (designDifference < parseFloat(minValues) || designDifference > parseFloat(maxValues)) {
        return 1;
      }
    }
  } else {
    return 7;
  }

  return 0;
}

function method15(parameter) {
  var results = "";
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var measureArray = measureValues.split(";");
  var min = Number.MAX_VALUE;
  var max = 0;

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var value = parseFloat(measureArray[idx]);
      min = min < value ? min : value;
      max = max > value ? max : value;
    }
  }

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var eachValue = parseFloat(measureArray[idx]);
      var difference = max - eachValue;
      var difference2 = eachValue - min;

      if (difference < parseFloat(minValues) || difference > parseFloat(maxValues) || difference2 < parseFloat(minValues) || difference2 > parseFloat(maxValues)) {
        if (results.length == 0) {
          results = "1";
        } else results += ";1";
      } else {
        if (results.length == 0) {
          results = "0";
        } else results += ";0";
      }
    } else {
      if (results.length == 0) {
        results = "9";
      } else results += ";9";
    }
  }

  return results;
}

function method16(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");
  var allDot = true;

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      allDot = false;
      var design = parseFloat(designValues);
      var max = parseFloat(maxValues);
      var difference = Math.abs(parseFloat(measureArray[idx]) - design);

      if (difference > design * max * 0.01) {
        return 1;
      }
    }
  }

  if (allDot) {
    return 9;
  } else {
    return 0;
  }
}

function method17(parameter) {
  var results = "";
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var limitValues = parameter.limitValues;
  var measureArray = measureValues.split(";");

  if (limitValues == 0) {
    limitValues = Number.MAX_VALUE;
  }

  var max = 0;

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var value = parseFloat(measureArray[idx]);
      max = max > value ? max : value;
    }
  }

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var difference = max - parseFloat(measureArray[idx]);

      if (difference > sortNum(limitValues)) {
        results = "";

        for (var i = 0; i < count(measureArray); i++) {
          if (results.length == 0) {
            results = "1";
          } else results += ";1";
        }

        return results;
      } else {
        if (difference < parseFloat(minValues) || difference > parseFloat(maxValues)) {
          if (results.length == 0) {
            results = "1";
          } else results += ";1";
        } else {
          if (results.length == 0) {
            results = "0";
          } else results += ";0";
        }
      }
    } else {
      if (results.length == 0) {
        results = "9";
      } else results += ";9";
    }
  }

  return results;
}

function method18(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  if (count(measureArray) == 0) {
    return 7;
  }

  var sum = 0;

  for (var i = 0; i < count(measureArray); i++) {
    sum += parseFloat(measureArray[i]);
  }

  var average = sum / count(measureArray);
  var difference = Math.abs(average - parseFloat(designValues));

  if (difference > parseFloat(maxValues) || difference < parseFloat(minValues)) {
    return 1;
  }

  return 0;
}

function method19(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  if (count(measureArray) != 2) {
    return 7;
  }

  var difference = Math.abs(parseFloat(measureArray[0]) - parseFloat(measureArray[1]));
  var final = difference - designValues;

  if (final > parseFloat(maxValues) || final < parseFloat(minValues)) {
    return 1;
  }

  return 0;
}

function method20(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  if (count(measureArray) == 0) {
    return 7;
  }

  var sum = 0;

  for (var i = 0; i < count(measureArray); i++) {
    sum += parseFloat(measureArray[i]);
  }

  var average = sum / count(measureArray);
  var difference = average - designValues;

  if (difference > parseFloat(maxValues) || difference < parseFloat(minValues)) {
    return 1;
  }

  return 0;
}

function method21(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  if (count(measureArray) < 2) {
    return 7;
  }

  var v1 = parseFloat(measureArray[0]);
  var v2 = parseFloat(measureArray[1]);
  var abs = Math.abs(v1 - v2);
  var difference = abs - designValues;

  if (difference > parseFloat(maxValues) || difference < parseFloat(minValues)) {
    return 1;
  }

  return 0;
}

function method22(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var designValues = parameter.designValues;
  var measureArray = measureValues.split(";");

  if (count(measureArray) == 0) {
    return 7;
  }

  var sum = 0;

  for (var i = 0; i < count(measureArray) - 1; i++) {
    var difference = Math.abs(parseFloat(measureArray[i + 1]) - parseFloat(measureArray[i]));
    sum += difference;
  }

  var average = sum / count(measureArray);
  var difference = average - designValues;

  if (difference > parseFloat(maxValues) || difference < parseFloat(minValues)) {
    return 1;
  }

  return 0;
} //开间进深类指标 两个设计值的结果点数有一个不合格两个都要变为不合格一个结果点 使用本算法   增加日期 2019-05-30  增加人张朝欣


function method23(parameter) {
  var measureValues = parameter.measureValues;
  var designValues = parameter.designValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var measureArray = measureValues.split(";");
  var allDot = true;

  for (var idx in measureArray) {
    var value = measureArray[idx];

    if (value != ".") {
      allDot = false;
      var difference = parseFloat(value) - designValues;

      if (parseFloat(difference) < minValues || parseFloat(difference) > maxValues) {
        return 1;
      }
    }
  }

  if (allDot == true) {
    return 9;
  }

  return 0;
} //顶板水平度类指标 且五个点算出一个结果点 使用本算法   增加日期 2019-05-30  增加人张朝欣


function method24(parameter) {
  var measureValues = parameter.measureValues;
  var maxValues = parameter.maxValues;
  var minValues = parameter.minValues;
  var limitValues = parameter.limitValues;
  var measureArray = measureValues.split(";");

  if (limitValues == 0) {
    limitValues = Number.MAX_VALUE;
  }

  var min = Number.MAX_VALUE;

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var value = parseFloat(measureArray[idx]);
      min = min < value ? min : value;
    }
  }

  for (var idx in measureArray) {
    if (measureArray[idx] != ".") {
      var difference = parseFloat(measureArray[idx]) - min;

      if (difference > sortNum(limitValues)) {
        return 1;
      } else {
        if (difference < minValues || difference > maxValues) {
          return 1;
        }
      }
    }
  }

  return 0;
}

function sortArray(arr1, arr2) {
  return count(arr1) - count(arr2);
}

function sortNum(limitValues) {
  if (limitValues == null || limitValues == "" || limitValues == "0") {
    return Number.MAX_VALUE;
  }

  return parseFloat(limitValues);
} //功能函数


function transArrayToStr(arr) {
  var str = "";

  for (var idx in arr) {
    if (str.length == 0) {
      str = arr[idx];
    } else str += ";" + arr[idx];
  }

  return str;
}

function logArrayContent(arr) {
  var str = "";
  arr.forEach(function (ele) {
    str += ele;
  });
  return str;
}

function count(obj) {
  var objType = _typeof(obj);

  if (objType == "string") {
    return obj.length;
  } else if (objType == "object") {
    var objLen = 0;

    for (var i in obj) {
      objLen++;
    }

    return objLen;
  }

  return false;
}

function clone(obj) {
  var temp = null;

  if (_instanceof(obj, Array)) {
    temp = obj.concat();
  } else if (_instanceof(obj, Function)) {
    //函数是共享的是无所谓的，js也没有什么办法可以在定义后再修改函数内容
    temp = obj;
  } else {
    temp = new Object();

    for (var item in obj) {
      var val = obj[item];
      temp[item] = _typeof(val) == 'object' ? clone(val) : val; //这里也没有判断是否为函数，因为对于函数，我们将它和一般值一样处理
    }
  }

  return temp;
}
//</script>
