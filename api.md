山东移动

信息化应用平台

SDK使用手册

应用平台

版本：v0.1


北京天云融创软件技术有限公司

2014-5-23

**版本**
<table>
<tr><td>**版本**</td><td>**修订时间** </td><td>**修订人** </td> <td>**修订内容**</td></tr>
<tr><td>**1.0**</td><td>2014/5/23</td><td> 孙明来</td><td>初始版本     </td></tr>
<tr><td>**1.1**</td><td>2014/6/16</td><td> 孙明来</td><td>完善各部分API</td></tr>
</table>




#编写目的

本手册供山东移动信息化应用平台第三方应用开发厂商作为参考规范第三方在开发应用的过程中，需要通过SDK来使用平台公共服务，此时需要参考此文档获取详细的SDK使用信息。

#范围
信息化应用平台 V1.0 SDK参考手册。

#参考资料
《山东移动 信息化应用平台 第三方应用开发规范》
违规开发与操作的责任与后果的说明
#SDK说明

##SDK简介

SDK（SoftwareDevelopmentKit），即软件开发工具包一般是一些被软件工程师用于为特定的软件包、软件框架、操作系统等建立应用软件的开发工具的集合。

提供SDK的目的是为了便于第三方应用的开发和部署。

获取到SDK之后，第三方应用开发厂商不需要直接与移动的各个服务系统去对接。在开发过程中，开发者只需要引入对应的SDK，并设置相应的环境变量，即可调用对应的接口，模拟调用移动的各个系统的服务。应用发布时，第三方开发者需要将对应的SDK一并制作在安装包中，当应用部署在信息化应用平台之后，第三方应用即可使用移动的各个服务。

在应用开发过程中，对移动各个服务系统的使用，必须按照SDK规定的方法进行访问和使用，若第三方开发者不按照规定的方法进行开发，需要对相应的结果负责。

应用平台提供的SDK主要包括：用户认证、客户数据管理、ICT能力、计量信息管理、关键数据同步以及平台公共能力等几个部分。

##JAVA SDK

为JAVA应用服务提供JAVA SDK，以JAR包的方式供第三方引用。

JAVA SDK主要分为3种JAR包：

1.  CommonSDK.jar：包含了用户认证、计量管理、客户数据管理等必须的接口和流程

2.  ICTSDK.jar：对移动ICT能力SDK的JAR包的统称，每种ICT能力对应了一个JAR包。例如SMSSDK.jar即为短彩能力SDK的JAR包。

3.  CommonConfig.jar：包含了ICT能力的配置信息，当用户引入新的ICT能力JAR包时，都需要对该JAR进行更新。

###Common SDK

**CommonSDK**为JAVA应用必须引用的JAR包，若不引用，第三方应用将无法正常工作。

公共SDK包括系统配置信息管理，用户认证管理（包括按次计量），成员信息管理，关键数据管理以及ICT能力管理5个模块。

Config模块负责获取公共配置，并提供给其他各个模块及ICT能力SDK使用。

Auth模块负责用户的单点登录，单点登出以及修改密码，并在登录或登出的同时通知计量服务进行相关的计量操作。

Member模块负责获取用户信息，成员信息以及部门信息等操作。

DataSync模块服务同步关键数据。

ICT模块负责提供ICT能力的统一出口。用户通过ICT的模块的工厂方法，获得对应ICT能力的对象，来进行ICT操作。

###SMS SDK& Common Config

SMS SDK即短彩能力SDK，为移动ICT能力SDK的一种。

所有ICT能力的SDK均实现Common SDK中所定义的ICT能力统一接口。所以SMS
SDK也实现了该统一接口，用以发送短信。所以，引入SMS
SDK之后，第三方即可调用短彩能力服务。

Common Config用于记录ICT能力与统一接口的关系，当第三方需要使用某个ICT能力时，需要同时引入ICT能力SDK的JAR包与CommonConfig.jar。不然用户将难以使用ICT能力。

###用户认证调用说明

第三方需要按照以下步骤来使用Common SDK所提供的用户认证功能。

首先需要实例化`AuthManager`对象,然后通过`AuthManager`对象调用`login`、`loginApp`、`logout`或`changePassword`接口，进行用户认证操作。

`AuthManager`全路径为：`com.sky.sdk.manager.AuthManager`

在实例化时，无参数。

####login接口

Login接口为用户认证接口，当用户需要使用信息化平台服务时，首先需要进行login操作，认证成功之后，平台会为用户分配一个临时的token，这样用户才能进行平台服务的使用。

接口详情：
```java
com.sky.sdk.model.LoginResponse response = com.sky.sdk.manager.AuthManager.login(String username, String password)
```
其中：

> 入参String username为登陆用户的用户名；
>
> 入参String password为登陆用户名对应的密码；
>
> 结果com.sky.sdk.model.LoginResponse
> response为用户登陆结果，其中携带用户认证令牌，在用户未登出或操作超时之前，作为用户的认证标识，在后续的用户操作中，作为用户的关键身份信息来使用。需要第三方应用进行相应的记录和管理。

`com.sky.sdk.model.LoginResponse`具体定义如下：
 <table>
 <tr><td> **属性名**</td><td> **类型**                 </td><td>  **描述**      </td></tr>
 <tr><td> token </td><td>   com.sky.sdk.model.SdkToken </td><td>  用户登录令牌  </td></tr>
 <tr><td> msg   </td><td>   String                     </td><td>  Login结果描述 </td></tr>
 <tr><td> code  </td><td>   Int                        </td><td>  Login结果码   </td></tr>
 </table>

注：

当执行成功时，code为“200”，msg为“ok”

当code为其他值时，login失败，msg则记录失败信息

其中，com.sky.sdk.model.SdkToken具体定义如下：
<table>
<tr><td>  **属性名**</td><td>   **类型**</td><td>  **描述**</td></tr>
<tr><td>  id        </td><td>   int </td><td>  请求id</td></tr>
<tr><td>  type      </td><td>   String  </td><td>  请求类型 CUSTOMER/APP `CUSTOMER为认证用户`</td></tr>
<tr><td>  ip        </td><td>   String  </td><td>  请求源ip</td></tr>
<tr><td>  userToken </td><td>   String  </td><td>  用户认证token</td></tr>
<tr><td>  appToken  </td><td>   String  </td><td>  应用认证token</td></tr>
<tr><td>  subjectId </td><td>   String  </td><td>  用户名的唯一标识</td></tr>
<tr><td>  expireTime</td><td>   String  </td><td>  过期时间</td></tr>
<tr><td>  agent     </td><td>   String  </td><td>  agent信息</td></tr>
<tr><td>  subject   </td><td>   String  </td><td>  用户名/APPID `当认证用户时为用户名`</td></tr>
</table>
####loginApp接口

当用户进入应用平之后，若需要使用某一种服务时，需要进行loginApp操作，来认证该用户是否能使用该应用

接口详情：
``` java
com.sky.sdk.model.LoginResponse token = com.sky.sdk.manager.AuthManager.loginApp(String userToken, String enterpriseId)
```

其中：

> 入参String userToken为用户执行login操作时得到的token；
>
> 入参String enterpriseId为用户执行getEnterpriseInfo操作时得到的结果，
> 详情请见2.2.4.2节；
>
> 结果`com.sky.sdk.model.LoginResponse`
> response为应用认证的结果，其中携带应用认证令牌，在用户未登出或操作超时之前，作为应用的认证标识，在后续的用户操作中，作为应用的关键信息来使用。需要第三方应用进行相应的记录和管理。

`com.sky.sdk.model.LoginResponse`具体定义如下：

<table>
<tr><td>  属性名 </td><td>  类型                       </td><td>  描述</td></tr>
<tr><td>  token  </td><td>  com.sky.sdk.model.SdkToken </td><td>  用户登录令牌</td></tr>
<tr><td>  msg    </td><td>  String                     </td><td>  LoginApp结果描述</td></tr>
<tr><td>  code   </td><td>  Int                        </td><td>  LoginApp结果码</td></tr>
</table>

注：

当执行成功时，code为“200”，msg为“ok”

当code为其他值时，LoginApp失败，msg则记录失败信息

其中，com.sky.sdk.model.SdkToken具体定义如下：
<table>
 <tr><td> 属性名      </td><td> 类型     </td><td> 描述</td></tr>
 <tr><td> id          </td><td> **int**  </td><td> 请求id</td></tr>
 <tr><td> type        </td><td> String   </td><td> 请求类型：CUSTOMER/APP APP为认证应用</td></tr>
 <tr><td> ip          </td><td> String   </td><td> 请求源ip</td></tr>
 <tr><td> userToken   </td><td> String   </td><td> 用户认证token</td></tr>
 <tr><td> appToken    </td><td> String   </td><td> 应用认证token</td></tr>
 <tr><td> subjectId   </td><td> String   </td><td> 用户名/APPID的唯一标识</td></tr>
 <tr><td> expireTime  </td><td> String   </td><td> 过期时间</td></tr>
 <tr><td> agent       </td><td> String   </td><td> agent信息</td></tr>
 <tr><td> subject     </td><td> String   </td><td> 用户名/APPID 认证应用时为APPID</td></tr>
</table>
####logout接口

接口详情：
```java
com.sky.sdk.model.SdkResponse result = com.sky.sdk.manager.AuthManager.logout(String userToken)
```

其中：

入参String userToken为用户登陆令牌，在用户执行login操作时得到。

com.sky.sdk.model.SdkResponse具体定义如下：
<table>
<tr><td>  属性名  </td><td> 类型    </td><td> 描述</td></tr>
<tr><td>  msg     </td><td> String  </td><td> Logout结果描述</td></tr>
<tr><td>  code    </td><td> Int     </td><td> Logout结果码</td></tr>
</table>

####2.2.3.4 changePassword接口

接口详情：
```java
com.sky.sdk.model.SdkResponse result = com.sky.sdk.manager.AuthManager.changePassword(String userToken, String oldPassword, String newPassword)
```
其中：

入参String
userToken为用户登陆令牌，在用户未登出或操作超时之前，用户的认证
标识，在后续的用户操作中，作为用户的关键身份信息来使用。需要第三方应用进行相应
的记录和管理。

入参String oldPassword为旧密码

入参String newPassword为新密码

`com.sky.sdk.model.SdkResponse`具体定义如下：
<table>
 <tr><td> 属性名  </td><td> 类型    </td><td> 描述</td></tr>
 <tr><td> msg     </td><td> String  </td><td> Login结果描述</td></tr>
 <tr><td> code    </td><td> Int     </td><td> Login结果码</td></tr>
</table>
注意：

如无特别说明，以下操作均需要在用户成功进行了login与loginApp之后才能执行，否则会因为认证信息不全而执行失败。

###客户数据操作说明记录

第三方需要按照以下步骤来使用Common SDK所提供的客户数据操作功能。

首先需要实例化MemberManager对象--\>然后通过MemberManager对象调用getCurrentUserInfo、getECMemberss、getDepartments和getDepartmentMenbers接口，获取用户的信息、获取成员或组织架构的信息。

MemberManager全路径为：com.sky.sdk.manager.MemberManager

在实例化时，无参数。

####查询用户信息接口

当应用需要查看用户的详细信息时，可调用该接口来获取。

该接口不需要用户登陆应用，即不需执行loginApp即可执行。

接口详情：
``` Java
String com.sky.sdk.manager.MemberManager.getCurrentUserInfo(String userToken)
```

其中：

> 入参String userToken为用户登陆令牌，在成功执行login操作时的返回结果；
>
> 执行结果为JSON字符串。
>
> 因当前为信息化应用平台使用前期，用户的信息会经常发
> 生变化，所以暂时将用户的
> 信息以JSON字符串的形式返回，SI可以根据应用对结果进行解析，待后续应用稳定
> 之后，再封装为类与对象

返回结果JSON字符串说明：

``` Javascript
{
    "code": [执行结果代码：成功为200；其他未失败],
    "customer":
    {
        "username": "[用户名]",
        "phone": "[登记电话]",
        "registerIp": [登记ip],
        "enterpriseId": [所属企业标识],
        "email": "[登记邮箱]",
        "gender": "[性别]",
        "newsLetter": [是否实时通信：true/false],
        "credentialNumber": [证件号],
        "credentialType": [证件类型],
        "lastUpdateDate": [最后一次更新时间],
        "createDate": [创建时间],
        "lastLoginDate": [最后一次登录时间],
        "isAdmin": [是否管理员：true/false],
        "customerGroupId": [所属群组id],
        "customerGroupName": [所属群组名],
        "enterpriseName": "test",
        "name": "[真实姓名]",
        "id": [唯一标识],
        "status": "[状态]"
    },
    "msg": "[执行结果描述：成功为ok；其他未失败]"\
}
```

####查询企业信息接口

当应用需要查看用户所加入企业的详细信息时，可调用该接口来获取。

该接口不需要用户登陆应用，即不需执行loginApp即可执行。

接口详情：
``` Java
String com.sky.sdk.manager.MemberManager.getEnterpriseInfo(String userToken)
```

其中：

> 入参String userToken为用户登陆令牌，在成功执行login操作时的返回结果；
>
> 执行结果为JSON字符串。
>
> 因当前为信息化应用平台使用前期，企业的信息会经常发
> 生变化，所以暂时将用户的
> 信息以JSON字符串的形式返回，SI可以根据应用对结果进行解析，待后续应用稳定
> 之后，再封装为类与对象

返回结果JSON字符串说明：
``` Javascript
{
    "code": [执行结果代码：成功为200；其他未失败],
    "msg": "[执行结果描述：成功为ok；其他未失败]",
    "enterprises":[
        {
            "name": "[企业名]",
            "id": [enterprseId]
        },
        {
            "name": "[企业名]",
            "id": [enterprseId]
        }
    ]
}
```

####查询全部成员信息接口

当应用需要查看所有成员的详细信息时，可调用该接口来获取。

接口详情：
``` Java
String com.sky.sdk.manager.MemberManager.getECMemberss(String userToken, String appToken)
```
其中：

> 入参String userToken为用户登陆令牌，在成功执行login操作时的返回结果；
>
> 入参String
> appToken为登陆应用令牌，在成功执行loginApp操作时的返回结果；
>
> 执行结果为JSON字符串。
>
> 因当前为信息化应用平台使用前期，用户的信息会经常发
> 生变化，所以暂时将用户的
> 信息以JSON字符串的形式返回，SI可以根据应用对结果进行解析，待后续应用稳定
> 之后，再封装为类与对象

返回结果JSON字符串说明：
``` Javascript
{
    "code": 200,
    "msg": "ok",
    "members": [
    {
        "username": "[用户名]",
        "phone": "[登记电话]",
        "registerIp": [登记ip],
        "enterpriseId": [所属企业标识],
        "email": "[登记邮箱]",
        "gender": "[性别]",
        "newsLetter": [是否实时通信：true/false],
        "credentialNumber": [证件号],
        "credentialType": [证件类型],
        "lastUpdateDate": [最后一次更新时间],
        "createDate": [创建时间],
        "lastLoginDate": [最后一次登录时间],
        "isAdmin": [是否管理员：true/false],
        "customerGroupId": [所属群组id],
        "customerGroupName": [所属群组名],
        "enterpriseName": "test",
        "name": "[真实姓名]",
        "id": [唯一标识],
        "status": "[状态]"
    },
    {
        "username": "[用户名]",
        "phone": "[登记电话]",
        "registerIp": [登记ip],
        "enterpriseId": [所属企业标识],
        "email": "[登记邮箱]",
        "gender": "[性别]",
        "newsLetter": [是否实时通信：true/false],
        "credentialNumber": [证件号],
        "credentialType": [证件类型],
        "lastUpdateDate": [最后一次更新时间],
        "createDate": [创建时间],
        "lastLoginDate": [最后一次登录时间],
        "isAdmin": [是否管理员：true/false],
        "customerGroupId": [所属群组id],
        "customerGroupName": [所属群组名],
        "enterpriseName": "test",
        "name": "[真实姓名]",
        "id": [唯一标识],
        "status": "[状态]"
    }]
}
```

####2.2.4.4 查询成员增量信息接口

当应用需要查看某一时间点之后成员增量的详细信息时，可调用该接口来获取。

接口详情：
``` Java
String com.sky.sdk.manager.MemberManager.getECMemberss(String userToken, String appToken, java.util.Date updateFrom)
```

其中：

> 入参String userToken为用户登陆令牌，在成功执行login操作时的返回结果；
>
> 入参String
> appToken为登陆应用令牌，在成功执行loginApp操作时的返回结果；
>
> 入参java.util.Date updateFrom为查询起始时间点，即在此时间点以后成员的
> 增量 信息均返回；
>
> 执行结果与2.2.4.2节相同，详情请见2.2.4.2节执行结果部分

####2.2.4.5 查询部门信息接口

当应用需要查看用户所在企业所有部门的详细信息时，可调用该接口来获取。

接口详情：
```Java
String com.sky.sdk.manager.MemberManager.getDepartments(String userToken, String appToken, boolean flat)
```

其中：

> 入参String userToken为用户登陆令牌，在成功执行login操作时的返回结果；
>
> 入参String
> appToken为登陆应用令牌，在成功执行loginApp操作时的返回结果；
>
> 入参boolean flat为返回结果显示格式，true--表示所有部门信息均以平级的列
> 表显展示；false--表示部门信息按照上下级关系以树状结构展示；
>
> 执行结果为JSON字符串。
>
> 因当前为信息化应用平台使用前期，用户企业的信息会经常发
> 生变化，所以暂时将用 户的
> 信息以JSON字符串的形式返回，SI可以根据应用对结果进行解析，待后续应用
> 稳定 之后，再封装为类与对象

返回结果JSON字符串说明：

I.当入参flat为true，以平级的列表展示：

```Javascript
{
    "code": 200,
    "msg": "ok",
    "departments": [
        {
        "name": "[部门名称]",
        "id": [departmentId],
        "phone": [注册电话],
        "parentDepartmentName": "[父部门名称]",
        "subDepartments": [子部门信息],
        "sort": [类别],
        "fax": [传真号],
        "personInCharge": [主管],
        "parentId": [父部门departmentId],
        "createDate": [创建时间],
        "status": [状态],
        "updateDate": [更新时间]
        },
        {
        "name": "[部门名称]",
        "id": [departmentId],
        "phone": [注册电话],
        "parentDepartmentName": "[父部门名称]",
        "subDepartments": [子部门信息],
        "sort": [类别],
        "fax": [传真号],
        "personInCharge": [主管],
        "parentId": [父部门departmentId],
        "createDate": [创建时间],
        "status": [状态],
        "updateDate": [更新时间]
        },
        {
        "name": "[部门名称]",
        "id": [departmentId],
        "phone": [注册电话],
        "parentDepartmentName": "[父部门名称]",
        "subDepartments": [子部门信息],
        "sort": [类别],
        "fax": [传真号],
        "personInCharge": [主管],
        "parentId": [父部门departmentId],
        "createDate": [创建时间],
        "status": [状态],
        "updateDate": [更新时间]
        },
        {
        "name": "[部门名称]",
        "id": [departmentId],
        "phone": [注册电话],
        "parentDepartmentName": "[父部门名称]",
        "subDepartments": [子部门信息],
        "sort": [类别],
        "fax": [传真号],
        "personInCharge": [主管],
        "parentId": [父部门departmentId],
        "createDate": [创建时间],
        "status": [状态],
        "updateDate": [更新时间]
        }
    ]
}
```
II.当入参flat为false，以树状结构展示：
```Javascript
{
    "code": 200,
    "msg": "ok",
    "departments": [
        {
            "name": "[部门名称]",
            "id": [departmentId],
            "phone": [注册电话],
            "subDepartments": //子部门信息
            [
                {
                    "name": "[子部门名称]",
                    "id": [子部门的departmentId],
                    "phone": [注册电话],
                    "subDepartments": [子部门信息],
                    "parentDepartmentName": "[父部门名称]",
                    "sort": [类别],
                    "fax": [传真号],
                    "personInCharge": [主管],
                    "parentId": [父部门departmentId],
                    "createDate": [创建时间],
                    "status": [状态],
                    "updateDate": [更新时间]
                },
                {
                    "name": "[子部门名称]",
                    "id": [子部门的departmentId],
                    "phone": [注册电话],
                    "subDepartments": [子部门信息],
                    "parentDepartmentName": "[父部门名称]",
                    "sort": [类别],
                    "fax": [传真号],
                    "personInCharge": [主管],
                    "parentId": [父部门departmentId],
                    "createDate": [创建时间],
                    "status": [状态],
                    "updateDate": [更新时间]
                }
            ],
            "parentDepartmentName": "[父部门名称]",
            "sort": [类别],
            "fax": [传真号],
            "personInCharge": [主管],
            "parentId": [父部门departmentId],
            "createDate": [创建时间],
            "status": [状态],
            "updateDate": [更新时间]
            },
            {
            "name": "[部门名称]",
            "id": [departmentId],
            "phone": [注册电话],
            "parentDepartmentName": "[父部门名称]",
            "subDepartments": [子部门信息],
            "sort": [类别],
            "fax": [传真号],
            "personInCharge": [主管],
            "parentId": [父部门departmentId],
            "createDate": [创建时间],
            "status": [状态],
            "updateDate": [更新时间]
        }
    ],
}
```
**2.2.4.6 查询部门增量信息接口**

当应用需要查看用户所在企业在某一时间点之后部门详细的增量信息时，可调用该接口来获取。

接口详情：String com.sky.sdk.manager.MemberManager.getDepartments(String
userToken, String appToken, java.util.Date updateFrom, boolean flat)

其中：

> 入参String userToken为用户登陆令牌，在成功执行login操作时的返回结果；
>
> 入参String
> appToken为登陆应用令牌，在成功执行loginApp操作时的返回结果；
>
> 入参java.util.Date updateFrom为查询起始时间点，即在此时间点以后部门的
> 增量 信息均返回；
>
> 入参boolean flat为返回结果显示格式，true--表示所有部门信息均以平级的列
> 表显展示；false--表示部门信息按照上下级关系以树状结构展示；
>
> 执行结果与2.2.4.4节相同，详情请见2.2.4.4节执行结果部分

###2.2.4.7 查询部门下可以使用应用成员的信息接口

当应用需要查看某个部门下可以使用该应用的成员的详细信息时，可调用该接口来获取。

接口详情：
```Java
String com.sky.sdk.manager.MemberManager.getDepartmentMenbers(String userToken, String appToken, String departmentId)
```

其中：

> 入参String userToken为用户登陆令牌，在成功执行login操作时的返回结果；
>
> 入参String
> appToken为登陆应用令牌，在成功执行loginApp操作时的返回结果；
>
> 入参String departmentId为部门id，在成功执行getDepartments操作时的
> 返回结果；
>
> 执行结果为JSON字符串。
>
> 因当前为信息化应用平台使用前期，成员的信息会经常发
> 生变化，所以暂时将成员的
> 信息以JSON字符串的形式返回，SI可以根据应用对结果进行解析，待后续应用稳定
> 之后，再封装为类与对象

返回结果JSON字符串说明：
```Javascript
{
    "code": 200,
    "msg": "ok",
    "members": [
        {
            "username": "[用户名]",
            "phone": "[登记电话]",
            "registerIp": [登记ip],
            "enterpriseId": [所属企业标识],
            "email": "[登记邮箱]",
            "gender": "[性别]",
            "newsLetter": [是否实时通信：true/false],
            "credentialNumber": [证件号],
            "credentialType": [证件类型],
            "lastUpdateDate": [最后一次更新时间],
            "createDate": [创建时间],
            "lastLoginDate": [最后一次登录时间],
            "isAdmin": [是否管理员：true/false],
            "customerGroupId": [所属群组id],
            "customerGroupName": [所属群组名],
            "enterpriseName": "test",
            "name": "[真实姓名]",
            "id": [唯一标识],
            "status": "[状态]"
        },
        {
            "username": "[用户名]",
            "phone": "[登记电话]",
            "registerIp": [登记ip],
            "enterpriseId": [所属企业标识],
            "email": "[登记邮箱]",
            "gender": "[性别]",
            "newsLetter": [是否实时通信：true/false],
            "credentialNumber": [证件号],
            "credentialType": [证件类型],
            "lastUpdateDate": [最后一次更新时间],
            "createDate": [创建时间],
            "lastLoginDate": [最后一次登录时间],
            "isAdmin": [是否管理员：true/false],
            "customerGroupId": [所属群组id],
            "customerGroupName": [所属群组名],
            "enterpriseName": "test",
            "name": "[真实姓名]",
            "id": [唯一标识],
            "status": "[状态]"
        }
    ]
}
```

####查询应用信息接口

当需要查询当前订购的应用的详细信息时，可调用该接口来获取。

接口详情：
```Java
String com.sky.sdk.manager.MemberManager. getCurrentInstance (String userToken, String appToken)
```

其中：

> 入参String userToken为用户登陆令牌，在成功执行login操作时的返回结果；
>
> 入参String
> appToken为登陆应用令牌，在成功执行loginApp操作时的返回结果；
>
> 返回结果；
>
> 执行结果为JSON字符串。

返回结果JSON字符串说明：
```Javascirpt
{
  "code": 200,
  "instance": {
    "openDate": null, //开通时间
    "productIcon": "1403651952769icon224-OA.png",//产品图标
    "productDesc": "通过对通知公告、公文管理、日程管理、资产管理等功能模块的开发建设，服务于广大集团客户，提高集团客户的工作效率和沟通效率。",//产品描述
    "config": "套餐:0元套餐",//配置信息
    "servicePort": null, //服务端口号
    "status": "available",//产品实例状态
    "price": 0, //价格
    "productName": "移动办公",//产品名称
    "operateStatus": "apply\_pass",//操作状态
    "expireDate": null, //过期时间
    "createDate": 1403717400000, //创建日期
    "specification": {
      "specItems": [
        {
          "Package": "0元套餐",//套餐名称
          "valueId": "15",//值ID
          "code": "Package",//套餐编码
          "propertyId": "9",//属性ID
          "componentType": "radio",//展示类型
          "sortOrder": "3",//顺序号
          "value": "3",//值
          "propertyName": "套餐"//属性名
        }
      ],
      "count": 0, //规格数量
      "sortOrder": 1, //顺序号
      "humanMonthPrice": 0, //人/月价
     "specNumber": "100101",//增值产品编码
      "isShow": null, //是否平台展示
      "humanYearPrice": null, //人/年价
      "onePrice": 0, //一口价
      "hourPrice": null, //包时价
      "dayPrice": null, //包天价
      "monthPrice": 0, //包月价
      "yearPrice": null, //包年价
      "specDesc": "0元套餐",//规格描述
      "showName": null, //规格显示名称
      "id": 74//规格ID
    },
    "installer": "1404285614617hx\_sd\_moa.apk",//安装包
   "name": "移动办公",//产品名称
    "id": 21, //产品实例ID
    "attributes": [
      {
        "code": "FirmwareVersion",//属性编码
        "display": "Android3.0及以上",//属性显示文字
        "propertyId": 10, //属性ID
        "name": "适合的固件版本",//属性名
        "value": "2",//属性值
       "id": 64, //ID
        "type": "label"//类型
      },
      {
        "code": "accessURL",//属性编码
        "display": "<http://223.99.248.3:8990/hx>",//属性显示文字
        "propertyId": 11, //属性ID
        "name": "访问地址",//属性名
        "value": "<http://223.99.248.3:8990/hx>",//属性值
        "id": 69, // ID
        "type": "hidden"//类型
      }
    ]
  },
  "msg": "ok"//MSG
}
```

### 计量信息操作说明

第三方需要按照以下步骤来使用Common SDK所提供的用户认证功能。

首先需要通过`CalculateManager.getInstance()`方法获取CalculateManager对象,然后通过CalculateManager对象调用calculatePerService接口，按照服务次数进行计量。

CalculateManager全路径为：com.sky.sdk.manager.CalculateManager

#### calculatePerService接口

接口详情：
```Java
com.sky.sdk.model.SdkResponse reult = com.sky.sdk.manager.CalculateManager.calculatePerService(com.sky.sdk.model.SdkToken token)
```

其中：

> 入参com.sky.sdk.model.SdkToken token为用户认证信息，其中uesrToken
> 与appToken为必填字段；

执行结果com.sky.sdk.model.SdkResponse具体定义如下：

<table>
 <tr><td> 属性名  </td><td> 类型    </td><td> 描述</td></tr>
 <tr><td> msg     </td><td> String  </td><td> calculate结果描述，SUCCEED为成功，其他为失败</td></tr>
 <tr><td> code    </td><td> Int     </td><td> calculate结果码，200为成功，其他为失败</td></tr>
</table>

### 关键数据同步操作说明 {#关键数据同步操作说明 .a9}

第三方需要按照以下步骤来使用Common SDK所提供的关键数据同步功能。

首先需要实例化DataSyncManager对象--\>然后通过DataSyncManager对象调用syncData接口，同步关键数据。

DataSyncManager全路径为：com.sky.sdk.manager.DataSyncManager

**2.2.6.1 syncData接口**

接口详情：
com.sky.sdk.model.SdkResponse reult = com.sky.sdk.manager.DataSyncManager.syncData(String userToken, String appToken, java.io.InputStream stream)

其中：

> 入参String userToken为用户登陆令牌，在成功执行login操作时的返回结果；
>
> 入参String
> appToken为登陆应用令牌，在成功执行loginApp操作时的返回结果；
>
> 入参java.io.InputStream stream为需要同步的数据流，数据流中数据的内容
> 需要为XML格式：

```XML
  \<?xml version="1.0" encoding="UTF-8"?\>

  \<!--其中appId是应用id，versionId是表的版本，tableName是表名，primaryKeyName是主键--\>

  \<table appId="a001" versionId="v0001" tableName="td\_s\_user" primaryKeyName="ID"\>

  \<datas\>

  \<data\>

  \<!—其中name是表的字段名称，\<column\>节点的内容是字段的值

  \<column name="ID"\>hdsff11dkhsdhf68s6df\</column\>

  \<column name="info"\>info\</column\>

  \<column name="nickname"\>sanxing\</column\>

  \<column name="password"\>123456\</column\>

  \<column name="username"\>syername\</column\>

  \</data\>

  \<data\>

  \<column name="ID"\>hkhsdhf63311128s6df1\</column\>

  \<column name="info"\>info1\</column\>

  \<column name="kname"\>sanxing1\</column\>

  \<column name="password"\>123456\</column\>

  \<column name="username"\>syername1\</column\>

  \</data\>

  … …

  \</datas\>

  \</table\>
```

注意：一个xml文件存储一张表的内容，一条数据放在`<data\>`节点下，没一个字段名是`<colum\>`节点的name属性值，`<column\>`节点的值是字段的值。

执行结果com.sky.sdk.model.SdkResponse具体定义如下：

  属性名   类型     描述
  -------- -------- ----------------------------------------
  msg      String   syncData结果描述，OK为成功，其他为失败
  code     Int      syncData结果码，0为成功，其他为失败

### 使用ICT能力说明 {#使用ict能力说明 .a9}

使用ICT能力以短彩能力为例来进行说明。

第三方需要按照以下步骤来使用Common SDK所提供的用户认证功能。

首先需要通过IctFactory.getInstance()方法获取IctFactory对象(单例模式)--\>然后通过IctFactory.getIctObj(ict\_service\_name)获取到ICT服务接口IctInterface的实现--\>最后，调用方法IctInterface.execute(IctParam
param, SdkToken token)发送短信。

其中：

IctFactory全路径为：com.sky.sdk.manager.IctFactory。

SdkToken全路径为：com.sky.sdk.model.SdkToken，详细信息请见2.2.3

ict\_service\_name为固定的String，短彩信服务的ict\_service\_name为“SMS”。

IctInterface全路径为：com.sky.sdk.ict.IctInterface，其中包含方法com.sky.sdk.model.SdkResponse
execute(com.sky.sdk.model.IctParam param, SdkToken token)与 void init()

**2.2.7.1 发短信接口**

**发短信接口**

接口详情：com.sky.sdk.model.SdkResponse response = <span id="OLE_LINK15"
class="anchor"><span id="OLE_LINK14"
class="anchor"></span></span>com.sky.ict.sms.
SmsIctImpl.execute(com.sky.sdk.model.SmsIctParam<span id="OLE_LINK5"
class="anchor"><span id="OLE_LINK6" class="anchor"></span></span> param,
com.sky.sdk.model.SdkToken token)

其中：

入参SmsIctParam
param必须继承自IctParam实体类，是短信参数实体类，定义如下：

  <span id="_Hlk388867945" class="anchor"><span id="OLE_LINK12" class="anchor"><span id="OLE_LINK13" class="anchor"></span></span></span>属性名   类型     描述                                       可否缺省
  ----------------------------------------------------------------------------------------------------------------------------------------------- -------- ------------------------------------------ ----------
  Mobs                                                                                                                                            String   短彩接收方的电话号码列表，以英文逗号连接   否
  Content                                                                                                                                         String   短彩内容，UTF-8编码                        否
  StartTime                                                                                                                                       Date     开始发送时间                               否
  EndTime                                                                                                                                         Date     结束发送时间                               否

入参SdkToken token为用户登录令牌，详细信息请见2.2.3节。

若通过SDK登陆，则token为2.2.3.1节返回结果中的token；若通过其他方式登陆，则
token为2.2.3.2接返回结果中的token。

结果：com.sky.sdk.model.SdkResponse response为操作结果实体类，定义如下：

  属性名   类型     描述       可否缺省
  -------- -------- ---------- ----------
  code     Int      操作结果   否
  msg      String   详细描述   是

用户根据code和desc判断操作是否成功，code=200表示成功否则是失败。

**2.2.7.2 LBS接口**

接口详情：com.sky.sdk.model.SdkResponse response = com.sky.ict.lbs.
LbsIctImpl.execute(com.sky.ict.lbs.LbsIctParam param,
com.sky.sdk.model.SdkToken token)

其中：

入参LbsIctParam
param必须继承自IctParam实体类，是短信参数实体类，定义如下：

  属性名         类型     描述             可否缺省
  -------------- -------- ---------------- ----------
  serialNumber   String   被定为手机号码   否

入参SdkToken token为用户登录令牌，详细信息请见2.2.3节。

若通过SDK登陆，则token为2.2.3.1节返回结果中的token；若通过其他方式登陆，则
token为2.2.3.2接返回结果中的token。

结果：com.sky.sdk.model.SdkResponse response为操作结果实体类，定义如下：

  属性名   类型     描述       可否缺省
  -------- -------- ---------- ----------
  code     Int      操作结果   否
  msg      String   详细描述   是

用户根据code和desc判断操作是否成功，code=200表示成功否则是失败。

### 查询账户绑定信息 {#查询账户绑定信息 .a9}

### 说明 {#说明 .a9}

com.sky.sdk.manager这个包下面有一个类：AccountBinding。这个类负责获取账户绑定的情况。使用的时候，需要先new这个类。然后调用其中的getBindingInfo方法。此方法需要传递两个参数，分别是userToke和appToken，都是String类型。无论请求成功与否，都会返回一个对象实例：BindingInfo，此对象位于包com.sky.sdk.manager下。

### 接口 {#接口 .a9}

类AccountBinding：

  返回值        方法描述
  ------------- --------------------------------------------------------------------------------------
  BindingInfo   **getBindingInfo**(java.lang.String userToken, java.lang.String appToken)           

类BindingInfo：

  返回值                方法描述
  --------------------- -----------------------------
  BindingInfo.Account   getAccount() 获取账户信息
  Int                   getCode() 获取返回的代码
  String                getMsg() 获取返回的描述信息

类 BindingInfo.Account

  返回值              方法描述
  ------------------- -------------------------------------------------------------------------------------------------------------------------------------
  java.lang.String    [getAccount](file:///C:\Users\gavin\Desktop\com\sky\sdk\model\BindingInfo.Account.html#getAccount())()     获取账户名称
   java.lang.String   [getDescription](file:///C:\Users\gavin\Desktop\com\sky\sdk\model\BindingInfo.Account.html#getDescription())()  获取描述信息
   long               [getId](file:///C:\Users\gavin\Desktop\com\sky\sdk\model\BindingInfo.Account.html#getId())()            获取id
   java.lang.String   [getInstanceId](file:///C:\Users\gavin\Desktop\com\sky\sdk\model\BindingInfo.Account.html#getInstanceId())()       获取应用实例的id
   java.lang.String   [getInstanceName](file:///C:\Users\gavin\Desktop\com\sky\sdk\model\BindingInfo.Account.html#getInstanceName())()     获取应用的名称

<span id="_Toc27670" class="anchor"><span id="_Toc26168" class="anchor"><span id="_Toc410996479" class="anchor"></span></span></span>开发示例 {#开发示例 .a8}
=============================================================================================================================================

<span id="_Toc20304" class="anchor"><span id="_Toc13501" class="anchor"><span id="_Toc410996480" class="anchor"></span></span></span>说明 {#说明-1 .a}
-----------------------------------------------------------------------------------------------------------------------------------------

<span id="_Toc313561787" class="anchor"><span id="_Toc324380542"
class="anchor"><span id="_Toc13352"
class="anchor"></span></span></span>本节以一个名为Sample简单的JAVA类为例，来演示一个第三方应用的开发流程，其中不包含第三方的具体业务。第三方在开发的过程中，根据业务逻辑的需要来组织SDK的调用流程，并编写相应的业务代码

<span id="_Toc25919" class="anchor"><span id="_Toc7718" class="anchor"><span id="_Toc410996481" class="anchor"></span></span></span>调用例子 {#调用例子 .a}
--------------------------------------------------------------------------------------------------------------------------------------------

### 登录及成员查询、数据同步，短信发送接口示例 {#登录及成员查询数据同步短信发送接口示例 .a9}

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
```Java
  **import** java.util.Date;

  **import** net.sf.json.JSONObject;

  **import** com.sky.ict.sms.SmsIctParam;

  **import** com.sky.sdk.exception.EnvironmentException;

  **import** com.sky.sdk.exception.SdkEmptyException;

  **import** com.sky.sdk.ict.IctInterface;

  **import** com.sky.sdk.manager.AuthManager;

  **import** com.sky.sdk.manager.IctFactory;

  **import** com.sky.sdk.manager.MemberManager;

  **import** com.sky.sdk.model.LoginResponse;

  **import** com.sky.sdk.model.SdkResponse;

  **import** com.skycloud.rs.model.SampleModel;

  **import** com.skycloud.rs.service.IExampleService;

  /\*\*

  \* example service implements.

  \*/

  **public** **class** ExampleServiceImpl **implements** IExampleService

  {

  /\*\*

  \* 实现登陆，查询用户数据等调用

  \*/

  **public** SampleModel testProcess(String username, String password)

  {

  SampleModel sample = **new** SampleModel();

  AuthManager authManager = **new** AuthManager();

  LoginResponse loginResponse;

  SdkResponse response;

  **Try**

  {

  //调用用户登陆接口，其中包含了loginApp

  loginResponse = authManager.login(username, password);

  //如果通过其他途径，用户已经登陆，则执行loginApp操作

  //loginResponse = authManager.loginApp(String userToken);

  //第二个参数为旧密码

  //第三个参数为新密码

  response = authManager.changePassword(loginResponse.getToken().getUserToken(), "password", "newpassword");

  MemberManager memberManager = **new** MemberManager();

  //查询登陆用户的详细信息

  String userResponse = memberManager.getCurrentUserInfo(loginResponse.getToken().getUserToken());

  //查询应用内所有成员的信息

  String multiUserInfos = memberManager.getECMembers(loginResponse.getToken().getUserToken(),

  loginResponse.getToken().getAppToken());

  //查询最近一周内应用内成员的增量信息

  Date ts = **new** Date(System.*currentTimeMillis*() - 7 \* 24 \* 60 \* 60 \* 1000);

  String multiUserInfosAWeekBefore = memberManager.getECMembers(loginResponse.getToken().getUserToken(),

  loginResponse.getToken().getAppToken(), ts);

  //获取部门信息，

  //第二个参数为enterpriseId，从获取成员信息的应答结果或获取用户信息的应答结果中解析

  String departmentInfo = memberManager.getDepartments(loginResponse.getToken().getUserToken(),

  loginResponse.getToken().getAppToken(), **true**);

  //获取部门成员信息，

  //第二个参数为enterpriseId，与获取部门信息相同，

  //第三个参数为departmentId，，从获取部门信息的应答结果中解析

  String departmentMembersInfo = memberManager.getDepartmentMenbers(loginResponse.getToken().getUserToken(),

  loginResponse.getToken().getAppToken(), "2");

  //如果需要发送短信，则需要先获取到发送短信的对象

  IctInterface smsSdk = IctFactory.*getInstance*().getIctObj("SMS");

  DataSyncManager dataSyncManager = **new** DataSyncManager();

  //生成需要同步的数据流

  InputStream stream = generateFile();

  response = dataSyncManager.syncData(loginResponse.getToken().getUserToken(),

  loginResponse.getToken().getAppToken(), stream);

  //尝试关闭数据流

  **try**

  {

  stream.close();

  }

  **catch** (IOException e)

  { }

  //操作结束，执行登出操作

  authManager.logout(loginResponse.getToken().getUserToken());

  sample.setUserToken(JSONObject.*fromObject*(loginResponse.getToken()).toString());

  sample.setClassName(smsSdk.getClass().getName());

  sample.setTime(**new** Date());

  } **catch** (EnvironmentException e) {

  // **TODO** Auto-generated catch block

  e.printStackTrace();

  } **catch** (SdkEmptyException e) {

  // **TODO** Auto-generated catch block

  e.printStackTrace();

  }

  **return** sample;

  }

  @RequestMapping(value = "/sendSMS", produces = { "text/html;charset=UTF-8" })

  @ResponseBody

  **public** String sendSMS(HttpServletRequest request, String phoneNumber, String smsContent) {

  System.*out*.println("sendSMS-----------------------------\>");

  System.*out*.println("phoneNumber:" + phoneNumber + ";;;smsContent:" + smsContent);

  LoginResponse *response* = (LoginResponse) request.getSession().getAttribute("loginResponse");

  SdkResponse resp = **null**;

  // 获取发送短信的接口实现对象

  IctInterface smsSdk = IctFactory.*getInstance*().getIctObj("SMS");

  // 设置调用参数

  SmsIctParam param = **new** SmsIctParam();

  param.setContent("信息化平台短信测试");//短信内容

  param.setMobs("18853188585,13639752892");//接收号码 多个手机号码，其中用逗号隔开

  param.setStartTime(**new** Date());//开始发送时间

  param.setEndTime(**new** Date(**new** Date().getTime()+24 \* 60 \* 60 \* 1000));//标识可以是当前时间后的一天之内发送

  //startTime 和 endTime是标识一个短信下发时间段，只有主机时间在标识的下发时间段里面短信才会下发，注意endTime不能小于当前时间，不然短信不下发，不能使用new Date（）；

  // 执行发送短信

  **try** {

  resp = smsSdk.execute(param, loginResponse.getToken());

  } **catch** (EnvironmentException e) {

  // **TODO** Auto-generated catch block

  e.printStackTrace();

  } **catch** (SdkEmptyException e) {

  // **TODO** Auto-generated catch block

  e.printStackTrace();

  }

  **return** "sendSMS phoneNumber:" + phoneNumber + ";;smsContent:" + smsContent + "send result:" + resp;

  }

  /\*\*

  \* 生成需校验的数据流

  \*/

  **private** InputStream generateFile()

  {

  StringBuffer sb = **new** StringBuffer();

  sb.append("\<?xml version=\\"1.0\\" encoding=\\"utf-8\\"?\>");

  sb.append("\<table tableName=\\"td\_s\_user\\" appId=\\"A001\\" versionId=\\"C001\\" primaryKeyName=\\"id\\"\>");

  sb.append("\<datas\>");

  //生成1000条需要校验的数据

  **for**(**int** i =0;i\<1000;i++)

  {

  String id = UUID.*randomUUID*().toString();

  sb.append("\<data\>");

  sb.append("\<column name=\\"id\\"\>id"+id+"\</column\>");

  sb.append("\<column name=\\"username\\"\>name"+id+"\</column\>");

  sb.append("\<column name=\\"nickname\\"\>nickname"+id+"\</column\>");

  sb.append("\<column name=\\"password\\"\>pasword"+id+"\</column\>");

  sb.append("\</data\>");

  }

  sb.append("\</datas\>");

  sb.append("\</table\>");

  String filePath = "d:/td\_s\_user.xml";

  InputStream in = **null**;

  **try**

  {

  //将数据写入文件，因一次性数据较多，直接转换会失败，所以先写入文件，再转换为数据流

  FileOutputStream out = **new** FileOutputStream(filePath);

  out.write(sb.toString().getBytes());

  out.close();

  //从文件中读取出数据流

  File f = **new** File("d:/td\_s\_user.xml");

  in = **new** FileInputStream(f);

  }

  **catch** (FileNotFoundException e)

  {

  e.printStackTrace();

  }

  **catch** (IOException e)

  {

  e.printStackTrace();

  }

  **return** in;

  }

  }
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

### LBS定位ICT接口示例 {#lbs定位ict接口示例 .a9}

  ----------------------------------------------------------------------------------------------
  LoginResponse response = (LoginResponse) request.getSession().getAttribute("loginResponse");

  // 获取LBS接口实现对象

  IctInterface lbsSdk = IctFactory.*getInstance*().getIctObj("LBS");

  // 设置调用参数

  LbsIctParam param = **new** LbsIctParam();

  param.setSerialNumber(serialNumber);

  SdkResponse resp = **null**;

  // 执行*lbs*服务调用

  **try** {

  resp = lbsSdk.execute(param, response.getToken());

  } **catch** (EnvironmentException e) {

  // **TODO** Auto-generated catch block

  e.printStackTrace();

  } **catch** (SdkEmptyException e) {

  // **TODO** Auto-generated catch block

  e.printStackTrace();

  }
```

