<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=false; section>
    <#if section = "header">
        <span class="duma-hidden-title">Duma</span>
    <#elseif section = "form">
        <div class="duma-login-shell">
            <section class="duma-form-panel">
                <div class="duma-form-card">
                    <div class="duma-brand-inner">
                        <img src="${url.resourcesPath}/img/logoDuma.png" alt="Logo Duma" class="duma-logo" />
                    </div>
                    <#if message?has_content>
                        <div class="duma-alert duma-alert-${message.type}">
                            ${kcSanitize(message.summary)?no_esc}
                        </div>
                    </#if>

                    <form id="kc-form-login" class="duma-login-form" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                        <#if !usernameHidden??>
                            <div class="duma-field">
                                <label for="username">
                                    <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                                </label>
                                <input
                                    tabindex="1"
                                    id="username"
                                    class="duma-input"
                                    name="username"
                                    value="${(login.username!'')}"
                                    type="text"
                                    autofocus
                                    autocomplete="username"
                                    aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                    placeholder="seu.email@empresa.com"
                                />
                            </div>
                        </#if>

                        <div class="duma-field">
                            <label for="password">${msg("password")}</label>
                            <input
                                tabindex="2"
                                id="password"
                                class="duma-input"
                                name="password"
                                type="password"
                                autocomplete="current-password"
                                aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                placeholder="Digite sua senha"
                            />
                        </div>

                        <div class="duma-form-meta">
                            <#if realm.rememberMe && !usernameHidden??>
                                <label class="duma-check">
                                    <#if login.rememberMe??>
                                        <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" checked />
                                    <#else>
                                        <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" />
                                    </#if>
                                    <span>${msg("rememberMe")}</span>
                                </label>
                            </#if>

                            <#if realm.resetPasswordAllowed>
                                <a tabindex="5" href="${url.loginResetCredentialsUrl}" class="duma-link">
                                    ${msg("doForgotPassword")}
                                </a>
                            </#if>
                        </div>

                        <#if auth?has_content && auth.showTryAnotherWayLink()>
                            <div class="duma-alt-action">
                                <a href="${url.loginRestartFlowUrl}" class="duma-link">${msg("doTryAnotherWay")}</a>
                            </div>
                        </#if>

                        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if> />

                        <button tabindex="4" class="duma-submit" name="login" id="kc-login" type="submit">
                            <span>${msg("doLogIn")}</span>
                        </button>
                    </form>

                    <p class="duma-legal">
                        Ao acessar, você concorda com os termos de uso da plataforma Duma.
                    </p>
                </div>
            </section>
        </div>
    </#if>
</@layout.registrationLayout>
